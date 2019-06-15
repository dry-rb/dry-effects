require 'concurrent/map'
require 'dry/effects'
require 'dry/effects/inflector'

module Dry
  module Effects
    default = %w(cache current_time random state interrupt amb retry fork parallel)

    effect_modules = ::Concurrent::Map.new

    default.each do |key|
      class_name = Inflector.camelize(key)

      if ::File.exists?("#{__dir__}/effects/#{key}.rb")
        effects.register(key, memoize: true) do
          require "dry/effects/effects/#{key}"
          Effects.const_get(Inflector.camelize(key))
        end

        singleton_class.class_eval do
          define_method(class_name) do |*args|
            effect_modules.fetch_or_store([key, args]) do
              ::Dry::Effects.effects[key].new(*args).freeze
            end
          end
        end
      end

      if ::File.exists?("#{__dir__}/providers/#{key}.rb")
        providers.register(key, memoize: true) do
          require "dry/effects/providers/#{key}"
          Providers.const_get(Inflector.camelize(key))
        end

        Handler.singleton_class.define_method(class_name) do |*args|
          ::Dry::Effects.providers[key].mixin(*args)
        end
      end
    end
  end
end
