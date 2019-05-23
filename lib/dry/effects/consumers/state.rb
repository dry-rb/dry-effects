module Dry
  module Effects
    module Consumers
      class State
        def initialize(initial)
          @state = initial
        end

        def read
          @state
        end

        def write(value)
          @state = value
        end

        def output(result)
          [@state, result]
        end
      end
    end
  end
end
