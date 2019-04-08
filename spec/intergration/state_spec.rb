require 'dry/effects/state'

RSpec.describe 'handling state' do
  let(:handler) do
    Dry::Effects::State::Handler.new
  end

  let(:effects) do
    Dry::Effects::State::Effects.new
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
