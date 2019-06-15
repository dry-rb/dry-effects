RSpec.describe 'stacked effects' do
  context 'different effect types' do
    include Dry::Effects.Random
    include Dry::Effects.CurrentTime

    let(:rand_handler) { make_handler(:random) }

    let(:time_handler) { make_handler(:current_time) }

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
        extend Dry::Effects.State(:counter_a), Dry::Effects.State(:counter_b)
      end

      let(:state_a) { make_handler(:state, :counter_a) }

      let(:state_b) { make_handler(:state, :counter_b) }

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
        extend Dry::Effects.State(:counter)
      end

      let(:state) { make_handler(:state, :counter) }

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

  context 'mixing two stack-affecting effects' do
    before do
      extend Dry::Effects.Amb(:feature)
      extend Dry::Effects.Interrupt(:stop)
      extend Dry::Effects::Handler[amb: :feature, as: :test_feature]
      extend Dry::Effects::Handler[interrupt: :stop, as: :catch]
    end

    example 'amb,interrupt' do
      expect(test_feature { catch { stop(feature?) } }).to eql([false, true])
    end

    example 'interrupt,amb' do
      expect(catch { test_feature { stop(feature?) } }).to eql(false)
    end

    context 'more nesting' do
      before do
        extend Dry::Effects.Amb(:feature2)
        extend Dry::Effects::Handler[amb: :feature2, as: :test_feature_2]
      end

      example 'interrupt,amb' do
        expect(test_feature { test_feature_2 { [feature?, feature2?] } }).to eql([
          [[false, false], [false, true]], [[true, false], [true, true]]
        ])
      end
    end
  end
end
