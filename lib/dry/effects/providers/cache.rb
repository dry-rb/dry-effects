# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Cache < Provider[:cache]
        param :scope

        option :cache, default: -> { ::Hash.new }

        include Dry::Equalizer(:scope, :cache)

        def fetch_or_store(key, block)
          if cache.key?(key)
            cache[key]
          else
            cache[key] = block.call
          end
        end

        def provide?(effect)
          super && scope.eql?(effect.scope)
        end
      end
    end
  end
end
