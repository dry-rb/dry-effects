require 'dry/effects/handler'
require 'dry/effects/cache'
require 'dry/effects/consumers/cache'

RSpec.describe 'handling random' do
  let(:handler) { Dry::Effects::Handler.new(:cache, :cached) }

  before do
    extend Dry::Effects::Cache.new(:cached)
  end

  example 'fetching cached values' do
    result = handler.() do
      [
        cached([1, 2, 3]) { :foo },
        cached([1, 2, 3]) { :bar }
      ]
    end

    expect(result).to eql([:foo, :foo])
  end
end
