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

        def call(_, cache = Undefined)
          @cache = Undefined.default(cache) { ::Hash.new }
          super
        end

        def provide?(effect)
          super && scope.eql?(effect.scope)
        end
      end
    end
  end
end
