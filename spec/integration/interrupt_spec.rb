# frozen_string_literal: true

RSpec.describe "handle interruption" do
  include Dry::Effects.Interrupt(:halt)
  include Dry::Effects::Handler.Interrupt(:halt, as: :catch_halt)
  include Dry::Effects::Handler.State(:counter_a, as: :outer)
  include Dry::Effects::Handler.State(:counter_b, as: :inner)

  it "aborts execution with payload" do
    result = outer(10) do
      catch_halt do
        inner(20) { halt :done }
      end
    end

    expect(result).to eql([10, [true, :done]])
  end

  it "aborts execution without payload" do
    result = outer(10) do
      catch_halt do
        inner(20) { halt }
      end
    end

    expect(result).to eql([10, [true, nil]])
  end

  it "returns result if no interruption was triggerred" do
    result = outer(10) do
      catch_halt { :success }
    end

    expect(result).to eql([10, [false, :success]])
  end

  context "stacked" do
    context "same identifiers" do
      include Dry::Effects.Interrupt(:halt)
      include Dry::Effects.Interrupt(:interrupt)
      include Dry::Effects::Handler.Interrupt(:halt, as: :handle_halt)
      include Dry::Effects::Handler.Interrupt(:interrupt, as: :handle_interrupt)

      example "handling within inner block" do
        _, outer = handle_halt do
          _, inner = handle_interrupt do
            interrupt 20
            10
          end
          halt inner + 10
          100
        end

        expect(outer).to be(30)
      end

      example "handling within outer block" do
        _, outer = handle_halt do
          _, inner = handle_interrupt do
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
