RSpec.describe Dry::Effects::Handler do
  describe '.[]' do
    let(:args) { [:current_time, as: :with_current_time] }

    let(:mod) { described_class[*args] }

    let(:klass) do
      mod = self.mod
      Class.new { include mod }
    end

    context 'random effect' do
      include Dry::Effects[:current_time]

      before do
        klass.class_exec do
          attr_reader :time

          def initialize(time)
            @time = time
          end

          def call
            with_current_time(time) do
              yield
            end
          end
        end
      end

      let(:frozen_time) { Time.now - 100 }

      it 'uses provides' do
        expect(klass.new(frozen_time).() { current_time }).to be(frozen_time)
      end
    end
  end
end
