require 'dry/effects'

RSpec.describe Dry::Effects do
  describe '.yield' do
    example 'with a fallback' do
      expect(Dry::Effects.yield(Object.new) { :fallback }).to be(:fallback)
    end
  end
end
