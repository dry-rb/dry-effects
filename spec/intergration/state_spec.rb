# frozen_string_literal: true

RSpec.describe 'handling state' do
  include Dry::Effects::Handler.State(:counter)
  include Dry::Effects.State(:counter)

  example 'manipulating state' do
    state, result = handle_state(0) do
      self.counter += 1
      self.counter += 1
      :done
    end

    expect(state).to be(2)
    expect(result).to be(:done)
  end

  example 'effectless' do
    state, result = handle_state(0) do
      :done
    end

    expect(state).to be(0)
    expect(result).to be(:done)
  end

  context 'missing state' do
    example 'with fallback' do
      expect(counter { :fallback }).to be(:fallback)
    end

    example 'without fallback' do
      expect { counter }.to raise_error(
        Dry::Effects::Errors::MissingState,
        /\+counter\+ is not set/
      )
    end
  end

  context 'default value' do
    include Dry::Effects.State(:counter, default: :fallback)

    example 'with no handler it returns default value' do
      expect(counter).to be(:fallback)
    end
  end

  context 'aliases' do
    include Dry::Effects.State(:counter, as: :cnt)

    it 'uses provided alias' do
      result = handle_state(0) do
        self.cnt += 1
        :done
      end

      expect(result).to eql([1, :done])
    end
  end
end
