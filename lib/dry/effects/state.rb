require 'dry/effects/effect'

module Dry
  module Effects
    class State < ::Module
      def initialize(identifier)
        read = Effect.new(:state, :read, identifier)
        write = Effect.new(:state, :write, identifier)

        module_eval do
          define_method(identifier) { Effects.yield(read) }
          define_method(:"#{identifier}=") { |value| Effects.yield(write.with(value)) }
        end
      end
    end
  end
end
