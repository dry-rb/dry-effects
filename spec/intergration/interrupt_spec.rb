RSpec.describe 'handle interruption' do
  include Dry::Effects[interrupt: :halt]
  include Dry::Effects::Handler[interrupt: :halt, as: :catch_halt]
  include Dry::Effects::Handler[state: :counter_a, as: :outer]
  include Dry::Effects::Handler[state: :counter_b, as: :inner]

  it 'aborts execution with payload' do
    result = outer(10) do
      catch_halt do
        inner(20) { halt :done }
      end
    end

    expect(result).to eql([10, :done])
  end

  it 'aborts execution without payload' do
    result = outer(10) do
      catch_halt do
        inner(20) { halt }
      end
    end

    expect(result).to eql([10, nil])
  end
end
