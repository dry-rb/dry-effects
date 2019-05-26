require 'dry/effects/providers/current_time'

RSpec.describe Dry::Effects::Providers::CurrentTime do
  subject(:current_time) { described_class.new }

  describe '#current_time' do
    it 'returns current time' do
      expect(current_time.current_time).to be_a(Time)
      expect(current_time.current_time).to be_within(2).of(Time.now)
    end

    context 'frozen time' do
      let(:frozen) { Time.now }

      subject(:current_time) { described_class.new(frozen) }

      it 'returns the same time' do
        expect(current_time.current_time).to be(frozen)
        sleep 0.01
        expect(current_time.current_time).to be(frozen)
      end
    end
  end
end

