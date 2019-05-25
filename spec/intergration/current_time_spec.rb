require 'dry/effects/handler'
require 'dry/effects/current_time'

RSpec.describe 'handling current time' do
  let(:handler) { Dry::Effects::Handler.new(:current_time) }

  let(:effects) { Object.new.extend(Dry::Effects::CurrentTime.new) }

  def current_time
    effects.current_time
  end

  context 'with default consumer' do
    context 'with not fixed time' do
      example 'producing random values' do
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
      example 'producing random values' do
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
