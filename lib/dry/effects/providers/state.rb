# frozen_string_literal: true

module Dry
  module Effects
    module Providers
      class State < Reader[:state]
        def write(value:)
          case value
          when state_type
            @state = value
          else
            Instructions.Raise(Errors::InvalidValueError.new(state, value))
          end
        end

        # Yield the block with the handler installed
        #
        # @api private
        def call(state = Undefined)
          r = super
          [self.state, r]
        end

        # @param [Effect] effect
        # @return [Boolean]
        # @api public
        def provide?(effect)
          effect.type.equal?(:state) && scope.equal?(effect.scope)
        end
      end
    end
  end
end
