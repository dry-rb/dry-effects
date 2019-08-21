# frozen_string_literal: true

require 'dry/effects/handler'

RSpec.describe 'handling current time' do
  include Dry::Effects.CurrentTime

  context 'with fixed time' do
    include Dry::Effects::Handler.CurrentTime

    example 'getting current timme' do
      before, after = with_current_time do
        before = current_time
        sleep 0.01
        after = current_time

        [before, after]
      end

      expect(before).to be(after)
    end

    example 'refreshing current time' do
      before, after = with_current_time do
        before = current_time
        sleep 0.01
        after = current_time(refresh: true)

        [before, after]
      end

      expect(before).to be < after
    end
  end

  context 'with provided time' do
    include Dry::Effects::Handler.CurrentTime

    example 'getting fixed time' do
      fixed = Time.now
      before, after = with_current_time(proc { fixed }) do
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
      before, after = with_current_time do
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
        time = with_current_time(proc { now }) { current_time }

        expect(time).to eql(now.round(1))
      end
    end

    context 'with method option' do
      include Dry::Effects::Handler.CurrentTime

      it 'rounds current time' do
        now = Time.now
        time = with_current_time(proc { now }) { current_time(round: 1) }

        expect(time).to eql(now.round(1))
      end

      context 'overriding' do
        include Dry::Effects.CurrentTime(round: 3)

        it 'overrides default option' do
          now = Time.now
          time = with_current_time(proc { now }) { current_time(round: 1) }

          expect(time).to eql(now.round(1))
        end
      end
    end

    context 'with handler option' do
      include Dry::Effects::Handler.CurrentTime(round: 1)

      it 'rounds current time' do
        now = Time.now
        time = with_current_time(proc { now }) { current_time }

        expect(time).to eql(now.round(1))
      end
    end

    context 'with non-fixed time' do
      include Dry::Effects::Handler.CurrentTime(round: 1, fixed: false)

      it 'rounds current time' do
        now = Time.now
        time = with_current_time { current_time }

        expect(time).to eql(now.round(1))
      end
    end
  end

  context 'custom time generator' do
    include Dry::Effects::Handler.CurrentTime

    let(:fixed) { Time.now }

    let(:generator) do
      current = nil

      lambda do |**|
        previous = current || fixed
        current = previous + 1
      end
    end

    it 'can use a custom time generator' do
      with_current_time(generator) do
        expect(current_time - current_time).to eql(-1.0)
        expect(current_time - current_time).to eql(-1.0)
      end
    end
  end

  context 'step time generator' do
    include Dry::Effects::Handler.CurrentTime

    it 'produces time at even intervals' do
      with_current_time(step: 0.1) do
        expect(current_time - current_time).to eql(-0.1)
        expect(current_time - current_time).to eql(-0.1)
      end
    end
  end

  context 'overriding with parent handler' do
    include Dry::Effects::Handler.CurrentTime

    it "delegates calls to parent if it's explicitly enabled" do
      fixed = Time.now

      with_current_time(proc { fixed }) do
        with_current_time(overridable: true) do
          expect(current_time).to be(fixed)
        end
      end
    end
  end
end
