require 'dry/effects/effect'

module Dry
  module Effects
    class Cache < ::Module
      def initialize(identifier)
        fetch_or_store = Effect.new(:cache, :fetch_or_store, Undefined.default(identifier) {
          raise ArgumentError, "Cache effect requires an identifier"
        })

        module_eval do
          define_method(identifier) do |key, &block|
            Effects.yield(fetch_or_store.with(key, block))
          end
        end
      end
    end
  end
end
