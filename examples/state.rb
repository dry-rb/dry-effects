Effects, Handlers = Dry::Effects.modules

class Operation
  include Effects::State[:counter]

  def call
    3.times do
      self.counter += 1
    end

    :done
  end
end

class Wrapper
  include Handlers::State[handle: :counter]

  def initialize
    @operation = Operation.new
  end

  def call
    handle(0) { @operation.call }
  end
end

__END__

Wrapper.new.call # => [:done, 3]
