require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Interrupt < Provider[:interrupt]
        def self.mixin(identifier, **kwargs)
          super(identifier: identifier, **kwargs)
        end

        option :signal, default: -> {
          :"effect_interrupt_interrupt_#{identifier}"
        }

        def interrupt(*payload)
          throw signal, payload
        end

        def call(_, _)
          caught = true
          result = catch(signal) do
            result = yield
            caught = false
            result
          end

          if caught
            result[0]
          else
            result
          end
        end
      end
    end
  end
end
