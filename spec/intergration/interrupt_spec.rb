RSpec.describe 'handle interruption' do
  include Dry::Effects.Interrupt(:halt)
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

  context 'stacked' do
    context 'same identifiers' do
      include Dry::Effects.Interrupt(:halt)
      include Dry::Effects.Interrupt(:raise)
      include Dry::Effects::Handler[interrupt: :halt, as: :catch_halt]
      include Dry::Effects::Handler[interrupt: :raise, as: :catch_raise]

      example 'handling within inner block' do
        outer = catch_halt do
          inner = catch_raise do
            raise 20
            10
          end
          halt inner + 10
          100
        end

        expect(outer).to be(30)
      end

      example 'handling within outer block' do
        outer = catch_halt do
          inner = catch_raise do
            halt 20
            10
          end
          halt inner + 10
          100
        end

        expect(outer).to be(20)
      end
    end
  end
end
