RSpec.describe Dry::Effects::Handler do
  describe '.[]' do
    let(:mod) { described_class[*args] }

    before { extend mod }

    context 'current time effect' do
      let(:args) { [:current_time, as: :with_current_time] }

      include Dry::Effects[:current_time]

      let(:frozen_time) { Time.now - 100 }

      it 'uses provided time' do
        expect(with_current_time(frozen_time) { current_time }).to be(frozen_time)
      end
    end

    context 'state effect' do
      include Dry::Effects[state: :counter]

      let(:args) { [state: :counter, as: :with_counter] }

      it 'uses provided state' do
        expect(with_counter(5) { self.counter += 7; :done }).to eql([12, :done])
      end
    end
  end
end
