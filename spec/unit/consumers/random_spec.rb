require 'dry/effects/consumers/random'

RSpec.describe Dry::Effects::Consumers::Random do
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

  describe '#output' do
    it 'returns result' do
      input = Object.new
      expect(random.output(input)).to be(input)
    end
  end
end
