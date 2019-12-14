# frozen_string_literal: true

require 'dry/effects/providers/defer'

RSpec.describe Dry::Effects::Providers::Defer do
  subject(:defer) { described_class.new }

  around { |ex| defer.(&ex) }

  describe '#dup' do
    it "prevents subsequent #later calls because it's not safe" do
      expect { defer.dup.later(double(:effect), double(:executor)).() }.to raise_error(
        Dry::Effects::Errors::EffectRejectedError,
        /\.later calls are not allowed/
      )
    end
  end

  describe '#represent' do
    it "shows default executor if it's a symbol" do
      expect(defer.represent).to eql('defer[io]')
    end

    context 'custom executor' do
      subject(:defer) { described_class.new(executor: double(:executor)) }

      it "doesn't show executor" do
        expect(defer.represent).to eql('defer')
      end
    end

    it 'shows number of later callables' do
      defer.later(-> {}, :immediate)
      expect(defer.represent).to eql('defer[io call_later=1]')
    end
  end
end
