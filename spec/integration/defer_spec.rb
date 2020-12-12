# frozen_string_literal: true

require "concurrent/array"

RSpec.describe "defer effects" do
  include Dry::Effects::Handler.Defer
  include Dry::Effects.Defer

  let(:null_executor) { NullExecutor.instance }

  describe "defer" do
    it "postpones blocks and schedules caller" do
      observed = Concurrent::Array.new
      values = nil

      result = with_defer do
        deferred = Array.new(3) do |i|
          defer do
            observed << :"step_#{i}"
            i
          end
        end

        observed << :start

        values = wait(deferred)

        :done
      end

      expect(result).to be(:done)
      expect(values).to eql([0, 1, 2])
      expect(observed.sort).to eql([:start, :step_0, :step_1, :step_2])
    end
  end

  describe "later" do
    include Dry::Effects.State(:counter)
    include Dry::Effects::Handler.State(:counter)
    include Dry::Effects::Handler.Defer(executor: :immediate)

    it "sends blocks to executor on finish" do
      results = Concurrent::Array.new

      with_defer do
        with_counter(10) do
          later { results << (self.counter += 11) }
          later { results << (self.counter += 12) }
        end
        expect(results).to eql([])
      end

      expect(results).to eql([21, 22])
    end
  end

  describe "choosing executor in handler" do
    include Dry::Effects.State(:counter)
    include Dry::Effects::Handler.State(:counter)
    include Dry::Effects::Handler.Defer

    context "with in-place executor" do
      it "accepts executor in handler" do
        results = Concurrent::Array.new

        with_defer(executor: :immediate) do
          with_counter(10) do
            later { results << (self.counter += 11) }
            later { results << (self.counter += 12) }
          end
          expect(results).to eql([])
        end

        expect(results).to eql([21, 22])
      end
    end

    context "without execution" do
      it "produces no output" do
        results = Concurrent::Array.new

        with_defer(executor: null_executor) do
          with_counter(10) do
            later { results << (self.counter += 11) }
            later { results << (self.counter += 12) }
          end
          expect(results).to eql([])
        end

        expect(results).to eql([])
      end
    end
  end

  describe "passing executor via context" do
    let(:executor) { CaptureExecutor.new }

    include Dry::Effects::Handler.Defer(executor: :immediate)

    context "with later" do
      it "uses passed executor" do
        called = false

        with_defer do
          later(executor: executor) { called = true }
        end

        expect(called).to be(false)
        executor.run_all
        expect(called).to be(true)
      end
    end

    context "with defer" do
      it "uses passed executor" do
        called = false

        with_defer do
          defer(executor: executor) { called = true }
        end

        expect(called).to be(false)
        executor.run_all
        expect(called).to be(true)
      end
    end
  end
end
