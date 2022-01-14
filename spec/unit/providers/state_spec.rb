# frozen_string_literal: true

require "dry/effects/providers/state"

RSpec.describe Dry::Effects::Providers::State do
  subject(:state) { described_class.new(:counter) }

  describe "#represent" do
    subject(:represented) { state.represent }

    context "not in stack" do
      it { is_expected.to eql("state[counter not set]") }
    end

    context "without value" do
      around { state.(Dry::Effects::Undefined, &_1) }

      it { is_expected.to eql("state[counter not set]") }
    end

    context "with value" do
      around { state.(10, &_1) }

      it { is_expected.to eql("state[counter set]") }
    end
  end
end
