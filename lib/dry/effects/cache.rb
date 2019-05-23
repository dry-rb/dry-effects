module Dry
  module Effects
    module Cache
      def fetch_or_store(key, &block)
        Fiber.yield([:fetch_or_store, key, block])
      end
    end
  end
end
