require 'dry/effects'
require 'dry/effects/inflector'

module Dry
  module Effects
    default = %w(cache current_time random state)

    default.each do |key|
      effects.register(key, memoize: true) do
        require "dry/effects/#{key}"
        const_get(Inflector.camelize(key))
      end
    end

    default.each do |key|
      consumers.register(key, memoize: true) do
        require "dry/effects/consumers/#{key}"
        Consumers.const_get(Inflector.camelize(key))
      end
    end
  end
end
