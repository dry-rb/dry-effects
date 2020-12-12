# frozen_string_literal: true

RSpec.describe "handling state" do
  include Dry::Effects::Handler.State(:counter)
  include Dry::Effects.State(:counter)

  example "manipulating state" do
    state, result = with_counter(0) do
      self.counter += 1
      self.counter += 1
      :done
    end

    expect(state).to be(2)
    expect(result).to be(:done)
  end

  example "effectless" do
    state, result = with_counter(0) do
      :done
    end

    expect(state).to be(0)
    expect(result).to be(:done)
  end

  context "missing state" do
    example "with fallback" do
      expect(counter { :fallback }).to be(:fallback)
    end

    example "without fallback" do
      expect { counter }.to raise_error(
        Dry::Effects::Errors::MissingStateError,
        /\+counter\+ is not set/
      )
    end
  end

  context "default value" do
    include Dry::Effects.State(:counter, default: :fallback)

    example "with no handler it returns default value" do
      expect(counter).to be(:fallback)
    end

    example "with value" do
      expect(with_counter(0) { counter }).to eql([0, 0])
    end
  end

  context "aliases" do
    include Dry::Effects.State(:counter, as: :cnt)

    it "uses provided alias" do
      result = with_counter(0) do
        self.cnt += 1
        :done
      end

      expect(result).to eql([1, :done])
    end
  end

  context "not defined state" do
    include Dry::Effects.State(:counter)

    it "can be called without providing state" do
      result = with_counter do
        self.counter = 10
        :done
      end

      expect(result).to eql([10, :done])
    end

    it "raises an error when undefined state is accessed" do
      with_counter do
        expect {
          counter
        }.to raise_error(Dry::Effects::Errors::UndefinedStateError, /\+counter\+/)
      end
    end

    it "returns default value if it is provided" do
      result = with_counter { counter { :fallback } }

      expect(result).to eql([Dry::Effects::Undefined, :fallback])
    end
  end

  context "type" do
    include Dry::Effects::Handler.State(:counter, type: Integer)

    it "accepts integer values" do
      result = with_counter(0) { self.counter += 10 }
      expect(result).to eql([10, 10])
    end

    it "rejects invalid values in handler" do
      expect { with_counter("") {} }.to raise_error(
        Dry::Effects::Errors::InvalidValueError,
        /invalid/
      )
    end

    it "rejects invalid values on assignment" do
      expect { with_counter(0) { self.counter = "" } }.to raise_error(
        Dry::Effects::Errors::InvalidValueError,
        /invalid/
      )
    end

    context "===" do
      include Dry::Effects::Handler.State(:counter, type: -> x { x.is_a?(Float) })

      it "uses case equality" do
        expect { with_counter(0) {} }.to raise_error(
          Dry::Effects::Errors::InvalidValueError
        )
      end
    end
  end

  describe "constructors" do
    include Dry::Effects::Constructors

    example "read effects" do
      expect(Read(:foo)).to eql(
        Dry::Effects::Effects::State::State.new(
          type: :state,
          name: :read,
          scope: :foo
        )
      )
    end

    example "write effects" do
      value = double(:value)
      expect(Write(:foo, value)).to eql(
        Dry::Effects::Effects::State::State.new(
          type: :state,
          name: :write,
          scope: :foo,
          payload: [value]
        )
      )
    end
  end
end
