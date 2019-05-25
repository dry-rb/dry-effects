require 'dry/effects/random'
require 'dry/effects/current_time'

RSpec.describe 'stacked effects' do
  let(:effects) { Object.new.extend(Dry::Effects::Random.new, Dry::Effects::CurrentTime.new) }

  let(:rand_handler) { Dry::Effects::Handler.new(:random) }

  let(:time_handler) { Dry::Effects::Handler.new(:current_time) }

  example 'nesting handlers' do
    past = Time.now
    future = rand_handler.() do
      time_handler.() do
        effects.current_time + effects.rand(100)
      end
    end

    expect(future).to be_between(past, past + 101)
  end
end
