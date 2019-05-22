require 'dry/effects/handler'
require 'dry/effects/random'

RSpec.describe 'handling random' do
  let(:consumer) do
    Class.new {
      def initialize(seed)
        @seed = seed
      end

      def rand(modulo)
        n = @seed % modulo
        shift
        n
      end

      def output(result)
        result
      end

      def shift
        @seed = @seed % 1000 + @seed / 1000
      end
    }.new(seed)
  end

  let(:handler) { Dry::Effects::Handler.new(consumer) }

  let(:effects) do
    Dry::Effects::Random::Effects.new
  end

  def rand(n)
    effects.rand(n)
  end

  context 'seed = 10' do
    let(:seed) { 121 }

    example 'getting random values' do
      result = handler.() do
        [rand(5), rand(9)]
      end

      expect(result).to eql([1, 4])
    end
  end
end
