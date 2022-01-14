# frozen_string_literal: true

require "dry/effects/providers/current_time"

RSpec.describe Dry::Effects::Providers::CurrentTime do
  subject(:current_time) { described_class.new }

  let(:generator) { Dry::Effects::Undefined }

  around { current_time.(generator, &_1) }

  describe "#current_time" do
    it "returns current time" do
      expect(current_time.current_time).to be_a(Time)
      expect(current_time.current_time).to be_within(2).of(Time.now)
    end

    context "frozen time" do
      let(:frozen) { Time.now }

      let(:generator) { proc { frozen } }

      it "returns the same time" do
        expect(current_time.current_time).to be(frozen)
        sleep 0.01
        expect(current_time.current_time).to be(frozen)
      end
    end
  end

  describe "#represent" do
    context "frozen" do
      let(:time) { Time.new(2019, 8, 9, 18, 50, 10.000002, 0) }

      before do
        current_time.(proc { time }) {}
      end

      it "shows current time" do
        expect(current_time.represent).to eql("current_time[fixed=2019-08-09T18:50:10.000002+00:00]")
      end
    end

    context "not frozen" do
      subject(:current_time) { described_class.new(fixed: false) }

      it "only shows that time in flux" do
        expect(current_time.represent).to eql("current_time[fixed=false]")
      end
    end

    context "not in the stack" do
      subject(:not_in_stack) { described_class.new }

      it "works" do
        expect(not_in_stack.represent).to eql("current_time[fixed=true]")
      end
    end
  end
end
