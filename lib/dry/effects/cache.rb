require 'dry/effects/effect'

module Dry
  module Effects
    class Cache < ::Module
      def initialize
        fetch_or_store = Effect.new(:cache, :fetch_or_store)

        module_eval do
          define_method(:fetch_or_store) do |key, &block|
            Effects.yield(fetch_or_store.with(key, block))
          end
        end
      end
    end
  end
end
