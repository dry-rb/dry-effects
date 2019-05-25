require 'dry/effects/effect'

module Dry
  module Effects
    module CurrentTime
      CURRENT_TIME = Effect.new(:current_time, :current_time)

      def current_time
        Fiber.yield(CURRENT_TIME)
      end
    end
  end
end
