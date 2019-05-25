require 'dry/effects/effect'

module Dry
  module Effects
    class State < ::Module
      def initialize
        read = Effect.new(:state, :read)
        write = Effect.new(:state, :write)

        module_eval do
          define_method(:read) { Effects.yield(read) }
          define_method(:write) { |value| Effects.yield(write.with(value)) }
        end
      end
    end
  end
end
