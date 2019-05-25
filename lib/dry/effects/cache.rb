require 'dry/effects/effect'

module Dry
  module Effects
    class Cache < ::Module
      FETCH_OR_STORE = Effect.new(:cache, :fetch_or_store)

      def initialize
        module_eval do
          def fetch_or_store(key, &block)
            Fiber.yield(FETCH_OR_STORE.with(key, block))
          end
        end
      end
    end
  end
end
