RSpec.describe 'handle interruption' do
  include Dry::Effects[interrupt: :halt]
  include Dry::Effects::Handler[interrupt: :halt, as: :catch_halt]
  include Dry::Effects::Handler[state: :counter_a, as: :outer]
  include Dry::Effects::Handler[state: :counter_b, as: :inner]

  it 'aborts execution with payload' do
    reached = false
    result = outer(10) do
      catch_halt do
        inner(20) { halt :done }
        reached = true
      end
    end

    expect(result).to eql([10, :done])
    expect(reached).to be(false)
  end

  it 'aborts execution without payload' do
    reached = false
    result = outer(10) do
      catch_halt do
        inner(20) { halt }
        reached = true
      end
    end

    expect(result).to eql([10, nil])
    expect(reached).to be(false)
  end

  it 'returns result if no interruption was triggerred' do
    result = outer(10) do
      catch_halt { :success }
    end

    expect(result).to eql([10, :success])
  end
end
