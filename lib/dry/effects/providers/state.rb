require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class State < Provider[:state]
        include Dry::Equalizer(:identifier, :state)

        attr_reader :state

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

        def call
          r = super
          [@state, r]
        end

        def represent
          "#{super}(#{@state})"
        end
      end
    end
  end
end
