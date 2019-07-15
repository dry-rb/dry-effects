# frozen_string_literal: true

require 'dry/effects/providers/reader'

module Dry
  module Effects
    module Providers
      class State < Reader[:state]
        def write(value)
          @state = value
        end

        def call(stack, state)
          r = super
          [self.state, r]
        end

        def provide?(effect)
          effect.type.equal?(:state) && scope.equal?(effect.scope)
        end
      end
    end
  end
end
