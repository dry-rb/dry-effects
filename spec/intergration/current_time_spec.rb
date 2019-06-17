# frozen_string_literal: true

require 'dry/effects/handler'

RSpec.describe 'handling current time' do
  include Dry::Effects::Handler.CurrentTime
  include Dry::Effects.CurrentTime

  context 'with default provider' do
    context 'with not fixed time' do
      example 'getting current timme' do
        before, after = handle_current_time do
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
        before, after = handle_current_time(Time.now) do
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
