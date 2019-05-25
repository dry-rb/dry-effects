require 'dry/effects/effect'

module Dry
  module Effects
    class Random < ::Module
      RAND = Effect.new(:random, :rand)

      def initialize
        module_eval do
          def rand(n)
            Fiber.yield(RAND.with(n))
          end
        end
      end
    end
  end
end
