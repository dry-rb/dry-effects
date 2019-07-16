# frozen_string_literal: true

RSpec.describe 'handling state' do
  context 'using reader handler' do
    include Dry::Effects::Handler.Reader(:user)
    include Dry::Effects.Reader(:user)

    let(:user_provided) { double(:user) }

    example 'accessing state in read-only mode' do
      result = with_user(user_provided) do
        expect(user).to be(user_provided)
        :done
      end

      expect(result).to be(:done)
    end
  end

  context 'using with state' do
    include Dry::Effects::Handler.State(:user)
    include Dry::Effects.Reader(:user)

    let(:user_provided) { double(:user) }

    example 'accessing state in read-only mode' do
      result = with_user(user_provided) do
        expect(user).to be(user_provided)
        :done
      end

      expect(result).to eql([user_provided, :done])
    end

    context 'when state is not set' do
      it 'raises an error is no default value provided' do
        with_user do
          expect { user }.to raise_error(Dry::Effects::Errors::UndefinedState)
        end
      end

      it 'returns default value if one is given and state handler has no initial value' do
        result = with_user { user { :fallback } }

        expect(result).to eql([Dry::Effects::Undefined, :fallback])
      end
    end
  end

  context 'renaming' do
    include Dry::Effects::Handler.State(:user)
    include Dry::Effects.Reader(:user, as: :current_user)

    let(:user_provided) { double(:user) }

    it 'uses provided alias' do
      result = with_user(user_provided) do
        expect(current_user).to be(user_provided)
        :done
      end

      expect(result).to eql([user_provided, :done])
    end
  end

  context 'type' do
    include Dry::Effects::Handler.Reader(:user, type: Hash)
    include Dry::Effects.Reader(:user)

    it 'accepts hash values' do
      result = with_user(name: 'John') { user }
      expect(result).to eql(name: 'John')
    end

    it 'rejects invalid values in handler' do
      expect { with_user([]) {} }.to raise_error(
        Dry::Effects::Errors::InvalidValue,
        /invalid/
      )
    end

    context '===' do
      include Dry::Effects::Handler.Reader(:user, type: -> x { x.is_a?(Struct) })

      it 'uses case equality' do
        user = Struct.new(:name)
        expect { with_user(0) {} }.to raise_error(Dry::Effects::Errors::InvalidValue)
        result = with_user(user.new(name: 'John')) { :done }
        expect(result).to be(:done)
      end
    end
  end
end
