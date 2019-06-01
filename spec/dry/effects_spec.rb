require 'dry/effects/providers/random'

RSpec.describe Dry::Effects do
  describe '.[]' do
    let(:mod) { described_class[*args] }

    before { extend mod }

    context 'random effect' do
      let(:handler) { make_handler(:random, :kernel) }

      let(:args) { [:random] }

      it 'mixes in effects' do
        expect(handler.() { rand(10) }).to be < 10
      end
    end

    context 'state effect' do
      let(:handler) { make_handler(:state, :counter) }

      let(:args) { [state: :counter] }

      it 'mixes in effects' do
        expect(handler.(2) { self.counter += 1; :done }).to eql([3, :done])
      end
    end
  end

  context 'without handlers' do
    before do
      extend Dry::Effects[:random]
    end

    example 'raising an effect results in an error' do
      expect { rand(10) }.to raise_error(
        Dry::Effects::Errors::UnhandledEffect,
        /not handled/
      )
    end
  end
end
