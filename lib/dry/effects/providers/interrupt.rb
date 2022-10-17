# frozen_string_literal: true

module Dry
  module Effects
    module Providers
      class Interrupt < Provider[:interrupt]
        param :scope, default: -> { :default }

        def interrupt(*payload)
          Instructions.Raise(halt.new(payload))
        end

        # Yield the block with the handler installed
        #
        # @api private
        def call
          [false, yield]
        rescue halt => e
          [true, e.payload[0]]
        end

        def halt
          Halt[scope]
        end

        # @return [String]
        # @api public
        def represent
          "interrupt[#{scope}]"
        end

        # @param [Effect] effect
        # @return [Boolean]
        # @api public
        def provide?(effect)
          super && scope.equal?(effect.scope)
        end
      end
    end
  end
end
