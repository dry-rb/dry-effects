module Dry
  module Effects
    module Consumers
      class Cache
        def initialize
          @cache = Hash.new
        end

        def fetch_or_store(key, block)
          if @cache.key?(key)
            @cache[key]
          else
            @cache[key] = block.call
          end
        end

        def output(result)
          result
        end
      end
    end
  end
end
