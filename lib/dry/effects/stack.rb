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
          !::Thread.current[:dry_effects_stack].nil?
        end

        def use(stack, &block)
          prev = current
          ::Thread.current[:dry_effects_stack] = stack
          stack.with_stack(&block)
        ensure
          ::Thread.current[:dry_effects_stack] = prev
        end
      end

      extend Initializer
      include Enumerable
      include Dry::Equalizer(:providers)

      param :providers, default: -> { [] }

      def initialize(*)
        super
        @error = nil
      end

      def call(effect)
        if effect.is_a?(Effect) && (provider = provider(effect))
          provider.public_send(effect.name, *effect.payload)
        elsif READ_ERROR.equal?(effect)
          error, @error = @error, nil
          error
        else
          yield
        end
      rescue Exception => @error
        FAIL
      end

      def push(provider)
        providers.unshift(provider)
        provider.() { yield }
      ensure
        providers.shift
      end

      def with_stack(&block)
        providers.map { |p| p.method(:call).to_proc }.reduce(:>>).(&block)
      end

      def provider(effect)
        find { |p| p.provide?(effect) }
      end

      def each(&block)
        providers.each(&block)
      end

      def size
        providers.size
      end

      def empty?
        providers.empty?
      end

      def dup
        Stack.new(map(&:dup))
      end

      def to_s
        if empty?
          "#<Dry::Effects::Stack>"
        else
          stack = map(&:represent).join('->')

          "#<Dry::Effects::Stack #{stack}>"
        end
      end
      alias_method :inspect, :to_s
    end
  end
end
