# frozen_string_literal: true

RSpec.describe 'defer effects' do
  include Dry::Effects::Handler.Defer
  include Dry::Effects.Defer

  let(:null_executor) { NullExecutor.instance }

  describe 'defer' do
    it 'postpones blocks and schedules caller' do
      observed = []
      values = nil

      result = handle_defer do
        deferred = Array.new(3) do |i|
          defer do
            sleep (3 - i).to_f / 30
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
      expect(observed).to eql([:start, :step_2, :step_1, :step_0])
    end
  end

  describe 'later' do
    include Dry::Effects.State(:counter)
    include Dry::Effects::Handler.State(:counter)
    include Dry::Effects::Handler.Defer(executor: :immediate)

    it 'sends blocks to executor on finish' do
      results = []

      handle_defer do
        handle_state(10) do
          later { results << (self.counter += 11) }
          later { results << (self.counter += 12) }
        end
        expect(results).to eql([])
      end

      expect(results).to eql([21, 22])
    end
  end

  describe 'choosing executor in handler' do
    include Dry::Effects.State(:counter)
    include Dry::Effects::Handler.State(:counter)
    include Dry::Effects::Handler.Defer

    context 'with in-place executor' do
      it 'accepts executor in handler' do
        results = []

        handle_defer(executor: :immediate) do
          handle_state(10) do
            later { results << (self.counter += 11) }
            later { results << (self.counter += 12) }
          end
          expect(results).to eql([])
        end

        expect(results).to eql([21, 22])
      end
    end

    context 'without execution' do
      it 'produces no output' do
        results = []

        handle_defer(executor: null_executor) do
          handle_state(10) do
            later { results << (self.counter += 11) }
            later { results << (self.counter += 12) }
          end
          expect(results).to eql([])
        end

        expect(results).to eql([])
      end
    end
  end
end
