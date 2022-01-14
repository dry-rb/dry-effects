# frozen_string_literal: true

require "dry/effects/initializer"
require "dry/effects/effect"
require "dry/effects/instructions/raise"

module Dry
  module Effects
    class Stack
      extend Initializer
      include Enumerable
      include Dry::Equalizer(:providers)

      param :providers, default: -> { [] }

      def call(effect)
        if effect.is_a?(Effect) && (provider = provider(effect))
          if effect.keywords.empty?
            provider.public_send(effect.name, *effect.payload)
          else
            provider.public_send(effect.name, *effect.payload, **effect.keywords)
          end
        else
          yield
        end
      rescue ::Exception => e # rubocop:disable Lint/RescueException
        Instructions::Raise.new(e)
      end

      def push(provider)
        providers.unshift(provider)
        yield
      ensure
        providers.shift
      end

      def provider(effect)
        find { _1.provide?(effect) }
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
          stack = map(&:represent).reverse.join("->")

          "#<Dry::Effects::Stack #{stack}>"
        end
      end
      alias_method :inspect, :to_s
    end
  end
end
