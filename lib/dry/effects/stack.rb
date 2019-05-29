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

      param :providers, default: -> { {} }

      def initialize(*)
        super
        @size = 0
        @error = nil
      end

      def call(effect)
        if effect.is_a?(Effect) && (provider = provider(effect))
          provider.public_send(effect.name, *effect.payload)
        elsif READ_ERROR.equal?(effect)
          error, @error = @error, nil
          error
        else
          Effects.yield(effect)
        end
      rescue Exception => @error
        FAIL
      end

      def push(type, provider)
        if providers.key?(type)
          providers[type].unshift(provider)
        else
          providers[type] = [provider]
        end
        @size += 1
        provider.() { yield }
      ensure
        providers[type].shift
        @size -= 1
      end

      def provider(effect)
        providers.fetch(effect.type, EMPTY_ARRAY).find do |p|
          effect.identifier.equal?(p.identifier)
        end
      end

      def empty?
        @size.zero?
      end
    end
  end
end
