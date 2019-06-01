require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Cache < Provider[:cache]
        def initialize(identifier:)
          super(identifier: identifier)

          @cache = Hash.new
        end

        def fetch_or_store(key, block)
          if @cache.key?(key)
            @cache[key]
          else
            @cache[key] = block.call
          end
        end
      end
    end
  end
end
