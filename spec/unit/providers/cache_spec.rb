# frozen_string_literal: true

RSpec.describe Dry::Effects::Providers::Cache do
  subject(:cache) { described_class.new(:test) }

  around { cache.(&_1) }

  describe "#fetch_or_store" do
    it "returns caches result" do
      missing = cache.fetch_or_store([1, 2, 3], -> { :foo })

      expect(missing.call).to be(:foo)
      expect(cache.fetch_or_store([1, 2, 3], -> { :bar })).to be(:foo)
    end
  end

  describe "#represent" do
    it "shows the number of elements" do
      expect(cache.represent).to eql("cache[test empty]")
      cache.cache[1] = 1
      expect(cache.represent).to eql("cache[test size=1]")
    end
  end
end
