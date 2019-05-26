require 'dry/effects'
require 'dry/effects/inflector'

module Dry
  module Effects
    default = %w(cache current_time random state interrupt amb retry)

    default.each do |key|
      effects.register(key, memoize: true) do
        require "dry/effects/#{key}"
        const_get(Inflector.camelize(key))
      end
    end

    default.each do |key|
      providers.register(key, memoize: true) do
        require "dry/effects/providers/#{key}"
        Providers.const_get(Inflector.camelize(key))
      end
    end
  end
end
