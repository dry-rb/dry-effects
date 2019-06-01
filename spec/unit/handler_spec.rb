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

  describe '#call' do
    context 'forking' do
      let(:handler) { make_handler(:state, :counter) }

      include Dry::Effects[state: :counter]
      include Dry::Effects[:fork]

      it 'duplicates a handler with the current stack' do
        result = handler.(0) do
          self.counter += 1
          fork do
            self.counter += 10
            :done
          end
        ensure
          self.counter += 1
        end

        expect(result).to eql([2, [11, :done]])
      end
    end
  end
end
