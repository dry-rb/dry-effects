module Dry
  module Effects
    module Random
      def rand(n)
        Fiber.yield([:rand, n])
      end
    end
  end
end
