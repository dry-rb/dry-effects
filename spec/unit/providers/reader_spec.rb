# frozen_string_literal: true

RSpec.describe Dry::Effects::Providers::Reader do
  subject(:reader) { described_class.new(:counter) }

  describe "#represent" do
    subject(:represented) { reader.represent }

    context "not in stack" do
      it { is_expected.to eql("reader[counter not set]") }
    end

    context "with value" do
      around { reader.(10, &_1) }

      it { is_expected.to eql("reader[counter set]") }
    end
  end
end
