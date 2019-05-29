require 'dry/effects/effect'

module Dry
  module Effects
    class State < ::Module
      def initialize(identifier)
        read = Effect.new(type: :state, name: :read, identifier: identifier)
        write = Effect.new(type: :state, name: :write, identifier: identifier)

        module_eval do
          define_method(identifier) { Effects.yield(read) }
          define_method(:"#{identifier}=") { |value| Effects.yield(write.payload(value)) }
        end
      end
    end
  end
end
