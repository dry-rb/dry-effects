# frozen_string_literal: true

require 'dry/effects/providers/state'

RSpec.describe Dry::Effects::Providers::Reader do
  subject(:reader) { described_class.new(:counter) }

  describe '#represent' do
    subject(:represented) { reader.represent }

    context 'not in stack' do
      it { is_expected.to eql('reader[counter unset]') }
    end

    context 'with value' do
      around { |ex| reader.(double(:stack), 10, &ex) }

      it { is_expected.to eql('reader[counter set]') }
    end
  end
end
