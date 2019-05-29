require 'dry/effects/errors'

RSpec.describe Dry::Effects::Stack do
  describe '#push' do
    include Dry::Effects[state: :words_counter]
    include Dry::Effects[state: :chars_counter]

    let(:handler) { Dry::Effects::Handler.new(:state, :words_counter) }

    let(:chars_counter_provider) do
      Dry::Effects.providers[:state].new(0, identifier: :chars_counter)
    end

    let!(:stack) { Dry::Effects::Stack.current }

    it 'combines two providers' do
      result = handler.(0) do
        self.words_counter += 1

        chars = stack.push(:state, chars_counter_provider) do
          self.words_counter += 1
          self.chars_counter += 10
          :done
        end

        self.words_counter += 2

        expect { chars_counter }.to raise_error(Dry::Effects::Errors::UnhandledEffect)

        chars
      end

      expect(result).to eql([4, [10, :done]])
    end
  end
end
