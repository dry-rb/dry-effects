module Dry
  module Effects
    module Random
      class Effects
        def rand(n)
          Fiber.yield([:rand, n])
        end
      end
    end
  end
end
