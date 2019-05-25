require 'dry/effects/consumer'

module Dry
  module Effects
    module Consumers
      class State < Consumer
        def initialize(initial, identifier:)
          super(identifier: identifier)
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
