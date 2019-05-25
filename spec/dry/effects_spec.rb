require 'dry/effects/consumers/random'

RSpec.describe Dry::Effects do
  describe '.[]' do
    let(:mod) { described_class[*args] }

    before { extend mod }

    context 'random effect' do
      let(:handler) { Dry::Effects::Handler.new(:random, :kernel) }

      let(:args) { [:random] }

      it 'mixes in effects' do
        expect(handler.() { rand(10) }).to be < 10
      end
    end

    context 'state effect' do
      let(:handler) { Dry::Effects::Handler.new(:state, :counter) }

      let(:args) { [state: :counter] }

      it 'mixes in effects' do
        expect(handler.(2) { self.counter += 1; :done }).to eql([3, :done])
      end
    end
  end
end
