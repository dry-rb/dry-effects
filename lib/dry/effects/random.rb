require 'dry/effects/effect'

module Dry
  module Effects
    module Random
      RAND = Effect.new(:random, :rand)

      def rand(n)
        Fiber.yield(RAND.with(n))
      end
    end
  end
end
