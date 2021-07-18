# frozen_string_literal: true

module Dry
  module Effects
    module Errors
      module Error
      end

      # No handler in the stack
      #
      # @api private
      class UnhandledEffectError < RuntimeError
        include Error

        attr_reader :effect

        def initialize(effect, message = Undefined)
          @effect = effect

          super(
            Undefined.default(message) {
              "Effect #{effect.inspect} not handled. "\
              "Effects must be wrapped with corresponding handlers"
            }
          )
        end
      end

      # No state handler
      #
      # @api private
      class MissingStateError < UnhandledEffectError
        def initialize(effect)
          message = "Value of +#{effect.scope}+ is not set, "\
                    "you need to provide value with an effect handler"

          super(effect, message)
        end
      end

      # Uninitialized state accessed
      #
      # @api private
      class UndefinedStateError < RuntimeError
        include Error

        def initialize(effect)
          message = "+#{effect.scope}+ is not defined, you need to assign it first "\
                    "by using a writer, passing initial value to the handler, or "\
                    "providing a fallback value"

          super(message)
        end
      end

      # Effect cannot be handled
      # Some effects are not compatible without re
      #
      # @api private
      class EffectRejectedError < RuntimeError
        include Error
      end

      # Unresolved dependency
      #
      # @api private
      class ResolutionError < RuntimeError
        include Error

        def initialize(key)
          super("Key +#{key.inspect}+ cannot be resolved")
        end
      end

      # State value has invalid type
      #
      # @api private
      class InvalidValueError < ArgumentError
        include Error

        def initialize(value, scope)
          super("#{value.inspect} is invalid and cannot be assigned to #{scope}")
        end
      end
    end
  end
end
