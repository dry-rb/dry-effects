module Dry
  module Effects
    module CurrentTime
      def current_time
        Fiber.yield([:current_time])
      end
    end
  end
end
