RSpec.describe Dry::Effects::Handler do
  describe '#call' do
    context 'forking' do
      let(:handler) { make_handler(:state, :counter) }

      include Dry::Effects.State(:counter)
      include Dry::Effects.Fork

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
