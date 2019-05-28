require 'dry/effects/initializer'
require 'dry/effects/effect'

module Dry
  module Effects
    class Stack
      class << self
        def current
          ::Thread.current[:dry_effects_stack] ||= new
        end

        def current?
          ::Thread.current.key?(:dry_effects_stack)
        end
      end

      extend Initializer

      attr_accessor :size

      param :providers, default: -> { {} }

      def initialize(*)
        super
        self.size = 0
      end

      def push(type, provider)
        if providers.key?(type)
          providers[type].unshift(provider)
        else
          providers[type] = [provider]
        end
        self.size += 1
        provider.() { yield }
      ensure
        providers[type].shift
        self.size -= 1
      end

      def provider(type, effect)
        if effect.is_a?(Effect)
          providers.fetch(type, EMPTY_ARRAY).find { |p| effect.identifier.equal?(p.identifier) }
        end
      end

      def empty?
        size.zero?
      end
    end
  end
end
