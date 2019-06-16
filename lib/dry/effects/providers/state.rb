require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class State < Provider[:state]
        def self.mixin(identifier, **kwargs)
          super(identifier: identifier, **kwargs)
        end

        include Dry::Equalizer(:identifier, :state)

        param :state

        def read
          @state
        end

        def write(value)
          @state = value
        end

        def call(*)
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
