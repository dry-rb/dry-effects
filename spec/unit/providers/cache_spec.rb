# frozen_string_literal: true

require 'dry/effects/providers/cache'

RSpec.describe Dry::Effects::Providers::Cache do
  subject(:cache) { described_class.new(:test) }

  around { |ex| cache.(double(:stack), &ex) }

  describe '#fetch_or_store' do
    it 'returns caches result' do
      missing = cache.fetch_or_store([1, 2, 3], -> { :foo })

      expect(missing.call).to be(:foo)
      expect(cache.fetch_or_store([1, 2, 3], -> { :bar })).to be(:foo)
    end
  end
end
