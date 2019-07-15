# frozen_string_literal: true

require 'dry/effects/handler'

RSpec.describe 'handling current time' do
  include Dry::Effects.CurrentTime

  context 'with fixed time' do
    include Dry::Effects::Handler.CurrentTime

    example 'getting current timme' do
      before, after = handle_current_time do
        before = current_time
        sleep 0.01
        after = current_time

        [before, after]
      end

      expect(before).to be(after)
    end
  end

  context 'with provided time' do
    include Dry::Effects::Handler.CurrentTime

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

  context 'with changing time' do
    include Dry::Effects::Handler.CurrentTime(fixed: false)

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

  context 'rounding' do
    context 'with effect mixin option' do
      include Dry::Effects::Handler.CurrentTime
      include Dry::Effects.CurrentTime(round: 1)

      it 'rounds current time' do
        now = Time.now
        time = handle_current_time(now) { current_time }

        expect(time).to eql(now.round(1))
      end
    end

    context 'with method option' do
      include Dry::Effects::Handler.CurrentTime

      it 'rounds current time' do
        now = Time.now
        time = handle_current_time(now) { current_time(round: 1) }

        expect(time).to eql(now.round(1))
      end
    end

    context 'with handler option' do
      include Dry::Effects::Handler.CurrentTime(round: 1)

      it 'rounds current time' do
        now = Time.now
        time = handle_current_time(now) { current_time }

        expect(time).to eql(now.round(1))
      end
    end

    context 'with non-fixed time' do
      include Dry::Effects::Handler.CurrentTime(round: 1, fixed: false)

      it 'rounds current time' do
        now = Time.now
        time = handle_current_time { current_time }

        expect(time).to eql(now.round(1))
      end
    end
  end
end
