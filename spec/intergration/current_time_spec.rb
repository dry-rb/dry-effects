require 'dry/effects/handler'
require 'dry/effects/current_time'

RSpec.describe 'handling current time' do
  let(:handler) { make_handler(:current_time) }
  include Dry::Effects[:current_time]

  context 'with default provider' do
    context 'with not fixed time' do
      example 'getting current timme' do
        before, after = handler.() do
          before = current_time
          sleep 0.01
          after = current_time

          [before, after]
        end

        expect(before).to be < after
      end
    end

    context 'with fixed time' do
      example 'getting fixed time' do
        before, after = handler.(Time.now) do
          before = current_time
          sleep 0.01
          after = current_time

          [before, after]
        end

        expect(before).to be(after)
      end
    end
  end
end
