# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Cache < ::Module
        class CacheEffect < Effect
          option :scope
        end

        def initialize(scope, as: :cache)
          fetch_or_store = CacheEffect.new(
            type: :cache,
            name: :fetch_or_store,
            scope: scope
          )

          module_eval do
            define_method(as) do |*args, &block|
              if block
                ::Dry::Effects.yield(fetch_or_store.(args, block))
              else
                ::Dry::Effects.yield(fetch_or_store.(args, -> { super(*args) }))
              end
            end
          end
        end
      end
    end
  end
end
