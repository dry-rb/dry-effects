require 'dry/effects/providers/cache'

RSpec.describe Dry::Effects::Providers::Cache do
  subject(:cache) { described_class.new(identifier: :test) }

  describe '#fetch_or_store' do
    it 'returns caches result' do
      expect(cache.fetch_or_store([1, 2, 3], -> { :foo })).to be(:foo)
      expect(cache.fetch_or_store([1, 2, 3], -> { :bar })).to be(:foo)
    end
  end
end

