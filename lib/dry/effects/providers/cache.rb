# frozen_string_literal: true

module Dry
  module Effects
    module Providers
      class Cache < Provider[:cache]
        include ::Dry::Equalizer(:scope, :cache, inspect: false)

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
        def call(cache = EMPTY_HASH.dup)
          @cache = cache
          yield
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
