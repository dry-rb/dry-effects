# frozen_string_literal: true

require "dry/system/container"

Dry::Effects.load_extensions(:auto_inject)

module Dry
  module Effects
    module System
      class AutoRegistrar < ::Dry::System::AutoRegistrar
        # Always memoize and freeze registered components
        def call(component_dir)
          components(component_dir).each do |component|
            next unless register_component?(component)

            container.register(component.key, memoize: true) { component.instance.freeze }
          end
        end
      end

      class Container < ::Dry::System::Container
        config.auto_registrar = AutoRegistrar

        def self.injector(effects: true, **kwargs)
          if effects
            Dry::Effects.AutoInject(**kwargs)
          else
            super()
          end
        end

        def self.finalize!
          return self if finalized?

          super

          # Force all components to load
          each_key { resolve(_1) }
          self
        end
      end
    end
  end
end
