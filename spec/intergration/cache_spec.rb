require 'dry/effects/handler'

RSpec.describe 'handling cache' do
  let(:handler) { make_handler(:cache, :cached) }

  include Dry::Effects[cache: :cached]

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
