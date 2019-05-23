require 'dry/effects/handler'
require 'dry/effects/random'

RSpec.describe 'handling random' do
  let(:handler) { Dry::Effects::Handler.new(consumer) }

  let(:effects) { Object.new.extend(Dry::Effects::Random) }

  def rand(n)
    effects.rand(n)
  end

  context 'with custom consumer' do
    let(:consumer) do
      Class.new do
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

        private

        def shift
          @seed = @seed % 1000 + @seed / 1000
        end
      end
    end

    context 'seed = 10' do
      let(:seed) { 121 }

      example 'getting random values' do
        result = handler.(seed) do
          [rand(5), rand(9)]
        end

        expect(result).to eql([1, 4])
      end
    end
  end

  context 'with default consumer' do
    let(:consumer) { Dry::Effects::Consumers::Random }

    example 'producing random values' do
      result = handler.() do
        Array.new(100) { rand(10) }
      end

      expect(result.max).to be < 10
    end
  end
end
