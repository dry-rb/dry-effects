# frozen_string_literal: true

RSpec.describe 'handling state' do
  context 'using reader handler' do
    include Dry::Effects::Handler.Reader(:user)
    include Dry::Effects.Reader(:user)

    let(:user_provided) { double(:user) }

    example 'accessing state in read-only mode' do
      result = handle_reader(user_provided) do
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
      result = handle_state(user_provided) do
        expect(user).to be(user_provided)
        :done
      end

      expect(result).to eql([user_provided, :done])
    end
  end
end
