# frozen_string_literal: true

require 'dry/effects/initializer'
require 'dry/effects/effect'
require 'dry/effects/instructions/raise'

module Dry
  module Effects
    class Stack
      extend Initializer
      include Enumerable
      include Dry::Equalizer(:providers)

      param :providers, default: -> { [] }

      def call(effect)
        if effect.is_a?(Effect) && (provider = provider(effect))
          provider.public_send(effect.name, *effect.payload)
        else
          yield
        end
      rescue ::Exception => e
        Instructions::Raise.new(e)
      end

      def push(provider)
        idx = size
        providers.unshift(provider)
        provider.(self, idx) { yield }
      ensure
        providers.shift
      end

      def with_stack(&block)
        providers.map.with_index { |p, i| -> &b { p.(self, i, &b) } }.reduce(:>>).(&block)
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
          '#<Dry::Effects::Stack>'
        else
          stack = map(&:represent).reverse.join('->')

          "#<Dry::Effects::Stack #{stack}>"
        end
      end
      alias_method :inspect, :to_s
    end
  end
end
