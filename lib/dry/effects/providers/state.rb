# frozen_string_literal: true

require 'dry/effects/providers/reader'
require 'dry/effects/instructions/raise'

module Dry
  module Effects
    module Providers
      class State < Reader[:state]
        def write(value)
          case value
          when state_type
            @state = value
          else
            Instructions.Raise(Errors::InvalidValue.new(state, value))
          end
        end

        def call(stack, state = Undefined)
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
