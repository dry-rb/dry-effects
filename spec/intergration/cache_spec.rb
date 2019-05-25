require 'dry/effects/handler'
require 'dry/effects/cache'
require 'dry/effects/consumers/cache'

RSpec.describe 'handling random' do
  let(:consumer) { Dry::Effects::Consumers::Cache }

  let(:handler) { Dry::Effects::Handler.new(consumer) }

  let(:effects) { Object.new.extend(Dry::Effects::Cache) }

  def fetch_or_store(n, &block)
    effects.fetch_or_store(n, &block)
  end

  example 'fetching cached values' do
    result = handler.() do
      [
        fetch_or_store([1, 2, 3]) { :foo },
        fetch_or_store([1, 2, 3]) { :bar }
      ]
    end

    expect(result).to eql([:foo, :foo])
  end
end
