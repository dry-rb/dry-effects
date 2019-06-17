require 'dry/effects/provider'
require 'dry/effects/instructions/raise'
require 'dry/effects/halt'

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
          Instructions.Raise(Halt[signal].new(payload))
        end

        def call(_, _)
          yield
        rescue Halt[signal] => e
          e.payload[0]
        end
      end
    end
  end
end
