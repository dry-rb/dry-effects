# frozen_string_literal: true

class Operation
  include Dry::Effects.State(:counter)

  def call
    3.times do
      self.counter += 1
    end

    :done
  end
end

class Wrapper
  include Dry::Effects::Handler.State(:counter)

  def initialize
    @operation = Operation.new
  end

  def call
    handle_state(0) { @operation.call }
  end
end

__END__

Wrapper.new.call # => [3, :done]
