# frozen_string_literal: true

require 'dry/system/container'

Dry::Effects.load_extensions(:auto_inject)

module Dry
  module Effects
    module System
      class AutoRegistrar < ::Dry::System::AutoRegistrar
        def call(dir)
          super do |config|
            config.memoize = true
            config.instance { |c| c.instance.freeze }
            yield(config) if block_given?
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
          each_key { |key| resolve(key) }
          self
        end
      end
    end
  end
end
