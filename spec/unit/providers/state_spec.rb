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
      around { |ex| state.(Dry::Effects::Undefined, &ex) }

      it { is_expected.to eql("state[counter not set]") }
    end

    context "with value" do
      around { |ex| state.(10, &ex) }

      it { is_expected.to eql("state[counter set]") }
    end
  end
end
