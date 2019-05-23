require 'dry/effects/consumers/state'

module Dry
  module Effects
    module State
      def read
        Fiber.yield([:read])
      end

      def write(value)
        Fiber.yield([:write, value])
      end
    end
  end
end
