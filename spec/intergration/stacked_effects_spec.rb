require 'dry/effects/random'
require 'dry/effects/current_time'

RSpec.describe 'stacked effects' do
  context 'nesting' do
    context 'different effect types' do
      before do
        extend Dry::Effects::Random.new, Dry::Effects::CurrentTime.new
      end

      let(:rand_handler) { Dry::Effects::Handler.new(:random) }

      let(:time_handler) { Dry::Effects::Handler.new(:current_time) }

      example 'nesting handlers' do
        past = Time.now
        future = rand_handler.() do
          time_handler.() do
            current_time + rand(100)
          end
        end

        expect(future).to be_between(past, past + 101)
      end
    end

    context 'same types' do
      context 'different identifier' do
        before do
          extend Dry::Effects::State.new(:counter_a), Dry::Effects::State.new(:counter_b)
        end

        let(:state_a) { Dry::Effects::Handler.new(:state, :counter_a) }

        let(:state_b) { Dry::Effects::Handler.new(:state, :counter_b) }

        example 'works nicely' do
          accumulated_state = state_a.(0) do
            state_b.(10) do
              self.counter_a += 4
              self.counter_b = counter_a + 20
              :result
            end
          end

          expect(accumulated_state).to eql([4, [24, :result]])
        end
      end

      context 'same identifier' do
        before do
          extend Dry::Effects[state: :counter]
        end

        let(:state) { Dry::Effects::Handler.new(:state, :counter) }

        example do
          accumulated_state = state.(0) do
            self.counter += 1
            state.(10) do
              self.counter += 30
              :result
            ensure
              self.counter += 50
            end
          ensure
            self.counter += 4
          end

          expect(accumulated_state).to eql([5, [90, :result]])
        end
      end
    end
  end
end
