require 'dry/effects/handler'

RSpec.describe 'handling cache' do
  include Dry::Effects::Handler.Cache(:cached)
  include Dry::Effects.Cache(:cached)

  example 'fetching cached values' do
    result = handle_cached do
      [
        cached([1, 2, 3]) { :foo },
        cached([1, 2, 3]) { :bar }
      ]
    end

    expect(result).to eql([:foo, :foo])
  end
end
