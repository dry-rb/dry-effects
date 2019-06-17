# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Cache < Provider[:cache]
        def self.mixin(identifier, **kwargs)
          super(identifier: identifier, **kwargs)
        end

        option :cache, default: -> { ::Hash.new }

        include Dry::Equalizer(:identifier, :cache)

        def fetch_or_store(key, block)
          if cache.key?(key)
            cache[key]
          else
            cache[key] = block.call
          end
        end
      end
    end
  end
end
