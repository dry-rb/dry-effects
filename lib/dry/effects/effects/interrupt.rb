require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Interrupt < ::Module
        def initialize(identifier = Undefined)
          interrupt = Effect.new(type: :interrupt, identifier: identifier)

          module_eval do
            define_method(identifier) do |payload = Undefined|
              if Undefined.equal?(payload)
                ::Dry::Effects.yield(interrupt)
              else
                ::Dry::Effects.yield(interrupt.payload(payload))
              end
            end
          end
        end
      end
    end
  end
end
