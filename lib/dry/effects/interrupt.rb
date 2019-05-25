require 'dry/effects/effect'

module Dry
  module Effects
    class Interrupt < ::Module
      def initialize(identifier = Undefined)
        interrupt = Effect.new(:interrupt, :interrupt, identifier)

        module_eval do
          define_method(identifier) do |payload = Undefined|
            if Undefined.equal?(payload)
              Effects.yield(interrupt)
            else
              Effects.yield(interrupt.with(payload))
            end
          end
        end
      end
    end
  end
end
