require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class State < Provider
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
