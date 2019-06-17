# frozen_string_literal: true

RSpec.describe 'handling state' do
  include Dry::Effects::Handler.State(:counter)
  include Dry::Effects.State(:counter)

  example 'manipulating state' do
    state, result = handle_counter(0) do
      self.counter += 1
      self.counter += 1
      :done
    end

    expect(state).to be(2)
    expect(result).to be(:done)
  end

  example 'effectless' do
    state, result = handle_counter(0) do
      :done
    end

    expect(state).to be(0)
    expect(result).to be(:done)
  end
end
