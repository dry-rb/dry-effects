require 'dry/effects/initializer'
require 'dry/effects/effect'

module Dry
  module Effects
    class Stack
      class << self
        def current
          ::Thread.current[:dry_effects_stack] ||= new
        end
      end

      extend Initializer

      param :providers, default: -> { {} }

      def push(type, provider)
        if providers.key?(type)
          providers[type].push(provider)
        else
          providers[type] = [provider]
        end
        provider.() { yield }
      ensure
        providers[type].pop
      end

      def provider(type, effect)
        if effect.is_a?(Effect)
          providers.fetch(type, EMPTY_ARRAY).find { |p| effect.identifier.equal?(p.identifier) }
        end
      end
    end
  end
end
