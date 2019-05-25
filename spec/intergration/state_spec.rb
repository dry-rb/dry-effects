require 'dry/effects/state'
require 'dry/effects/consumers/state'

RSpec.describe 'handling state' do
  let(:consumer) { Dry::Effects::Consumers::State }

  let(:handler) do
    Dry::Effects::Handler.new(consumer)
  end

  let(:effects) do
    Dry::Effects::State.new
  end

  def inc
    effects.write(effects.read + 1)
  end

  example 'manipulating state' do
    state, result = handler.(0) do
      inc
      inc
      :done
    end

    expect(state).to be(2)
    expect(result).to be(:done)
  end

  example 'effectless' do
    state, result = handler.(0) do
      :done
    end

    expect(state).to be(0)
    expect(result).to be(:done)
  end
end
