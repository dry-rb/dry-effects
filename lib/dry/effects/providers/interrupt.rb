# frozen_string_literal: true

require 'dry/effects/provider'
require 'dry/effects/instructions/raise'
require 'dry/effects/halt'

module Dry
  module Effects
    module Providers
      class Interrupt < Provider[:interrupt]
        param :scope, default: -> { :default }

        def interrupt(*payload)
          Instructions.Raise(halt.new(payload))
        end

        def call(_, _)
          yield
        rescue halt => e
          e.payload[0]
        end

        def halt
          Halt[scope]
        end

        def provide?(effect)
          super && scope.equal?(effect.scope)
        end
      end
    end
  end
end
