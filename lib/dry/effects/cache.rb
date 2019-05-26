require 'dry/effects/effect'

module Dry
  module Effects
    class Cache < ::Module
      def initialize(identifier)
        fetch_or_store = Effect.new(
          type: :cache,
          name: :fetch_or_store,
          identifier: identifier
        )

        module_eval do
          define_method(identifier) do |key, &block|
            Effects.yield(fetch_or_store.payload(key, block))
          end
        end
      end
    end
  end
end
