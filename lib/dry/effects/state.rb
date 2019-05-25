require 'dry/effects/effect'

module Dry
  module Effects
    class State
      READ = Effect.new(:state, :read)
      WRITE = Effect.new(:state, :write)

      def read
        Fiber.yield(READ)
      end

      def write(value)
        Fiber.yield(WRITE.with(value))
      end
    end
  end
end
