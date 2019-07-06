# frozen_string_literal: true

module Dry
  module Effects
    module Errors
      module Error
      end

      class UnhandledEffect < RuntimeError
        include Error

        attr_reader :effect

        def initialize(effect, message = Undefined)
          @effect = effect

          super(
            Undefined.default(message) {
              "Effect #{effect.inspect} not handled. "\
              'Effects must be wrapped with corresponding handlers'
            }
          )
        end
      end

      class MissingState < UnhandledEffect
        def initialize(effect)
          message = "Value of +#{effect.scope}+ is not set, "\
                    'you need to provide value with an effect handler'

          super(effect, message)
        end
      end
    end
  end
end
