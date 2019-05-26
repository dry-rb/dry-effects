require 'dry/effects/providers/random'

RSpec.describe Dry::Effects::Providers::Random do
  subject(:random) { described_class.new }

  describe '#rand' do
    it 'returns an integer for positive integers' do
      srand(100)
      first = Array.new(10) { random.rand(10) }
      srand(100)
      second = Array.new(10) { random.rand(10) }

      expect(first).to eql(second)
    end
  end
end
