# frozen_string_literal: true

require "concurrent/map"
require "dry/auto_inject/strategies/constructor"
require "dry/effects/effects/resolve"

module Dry
  module Effects
    class DryAutoEffectsStrategies
      extend Dry::Container::Mixin

      class Base < AutoInject::Strategies::Constructor
        private

        def define_new
          # nothing to do
        end

        def define_initialize(_)
          # nothing to do
        end
      end

      class Static < Base
        private

        def define_readers(dynamic = false) # rubocop:disable Style/OptionalBooleanParameter
          map = dependency_map.to_h
          cache = ::Concurrent::Map.new
          instance_mod.class_exec do
            map.each do |name, identifier|
              resolve = ::Dry::Effects::Constructors::Resolve(identifier)

              if dynamic
                define_method(name) { ::Dry::Effects.yield(resolve) }
              else
                define_method(name) do
                  cache.fetch_or_store(name) do
                    ::Dry::Effects.yield(resolve)
                  end
                end
              end
            end
          end
          self
        end
      end

      class Dynamic < Static
        private

        def define_readers(dynamic = true) # rubocop:disable Style/OptionalBooleanParameter
          super
        end
      end

      register :static, Static
      register :dynamic, Dynamic
      register :default, Static
    end

    def self.AutoInject(dynamic: false)
      mod = Dry.AutoInject(EMPTY_HASH, strategies: DryAutoEffectsStrategies)
      dynamic ? mod.dynamic : mod
    end
  end
end
