# frozen_string_literal: true

require 'dry/effects/provider'
require 'dry/effects/instructions/execute'

module Dry
  module Effects
    module Providers
      class Cache < Provider[:cache]
        include Dry::Equalizer(:scope, :cache)

        param :scope

        attr_reader :cache

        def fetch_or_store(key, block)
          if cache.key?(key)
            cache[key]
          else
            Instructions.Execute { cache[key] = block.call }
          end
        end

        # Yield the block with the handler installed
        #
        # @api private
        def call(stack, cache = EMPTY_HASH.dup)
          @cache = cache
          super(stack)
        end

        # @param [Effect] effect
        # @return [Boolean]
        # @api public
        def provide?(effect)
          super && scope.eql?(effect.scope)
        end

        # @return [String]
        # @api public
        def represent
          if cache.empty?
            "cache[#{scope} empty]"
          else
            "cache[#{scope} size=#{cache.size}]"
          end
        end
      end
    end
  end
end
