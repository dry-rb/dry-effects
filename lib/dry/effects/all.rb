require 'dry/effects'
require 'dry/effects/inflector'

module Dry
  module Effects
    default = %w(cache current_time random state interrupt amb retry fork parallel)

    default.each do |key|
      if File.exists?("#{__dir__}/effects/#{key}.rb")
        effects.register(key, memoize: true) do
          require "dry/effects/effects/#{key}"
          Effects.const_get(Inflector.camelize(key))
        end
      end

      if File.exists?("#{__dir__}/providers/#{key}.rb")
        providers.register(key, memoize: true) do
          require "dry/effects/providers/#{key}"
          Providers.const_get(Inflector.camelize(key))
        end
      end
    end
  end
end
