# frozen_string_literal: true

require 'dry/effects/handler'

RSpec.describe 'handling current time' do
  include Dry::Effects.Timestamp

  context 'with custom generator' do
    include Dry::Effects::Handler.Timestamp

    example 'getting a timestamp' do
      fixed = Time.now
      before, after = with_timestamp(proc { fixed }) do
        before = timestamp
        sleep 0.01
        after = timestamp

        [before, after]
      end

      expect(before).to be(after)
    end
  end

  context 'with step' do
    include Dry::Effects::Handler.Timestamp

    it 'uses the given step as an interval' do
      with_timestamp(step: 0.1) do
        expect(timestamp - timestamp).to eql(-0.1)
        expect(timestamp - timestamp).to eql(-0.1)
      end
    end

    context 'with initial value' do
      it 'can be passed as a start value' do
        initial = Time.now + 100

        with_timestamp(step: 0.1, initial: initial) do
          expect(timestamp - initial).to eql(0.0)
          expect(timestamp - timestamp).to eql(-0.1)
        end
      end
    end
  end

  context 'with rounding' do
    context 'in handler' do
      include Dry::Effects::Handler.Timestamp(round: 3)

      it 'applies mixin argument' do
        fixed = Time.now

        with_timestamp(proc { fixed }) do
          expect(timestamp(round: 3)).to eql(fixed.round(3))
        end
      end

      it 'can be overridden' do
        fixed = Time.now

        with_timestamp(proc { fixed }) do
          expect(timestamp(round: 1)).to eql(fixed.round(1))
        end
      end
    end

    context 'in caller' do
      include Dry::Effects::Handler.Timestamp

      it 'can be passed' do
        fixed = Time.now

        with_timestamp(proc { fixed }) do
          expect(timestamp(round: 3)).to eql(fixed.round(3))
        end
      end
    end
  end

  context 'overridding' do
    include Dry::Effects::Handler.Timestamp

    it 'can be overridden' do
      fixed = Time.now
      with_timestamp(proc { fixed }) do
        with_timestamp(overridable: true) do
          expect(timestamp).to be(fixed)
        end
      end
    end
  end
end
