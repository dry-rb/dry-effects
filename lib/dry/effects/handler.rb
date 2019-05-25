require 'fiber'
require 'dry/effects/effect'

module Dry
  module Effects
    class Handler
      def self.[](effect = Undefined, as:, **kwargs)
        if Undefined.equal?(effect)
          type, identifier = kwargs.to_a.first
        else
          type, identifier = effect, Undefined
        end

        handler = new(type, identifier)

        Module.new do
          define_method(as) { |*args, &block| handler.(*args, &block) }
        end
      end

      attr_reader :consumers, :effect_type, :identifier

      def initialize(effect_type, identifier = Undefined, consumers: Effects.consumers)
        @consumers = consumers
        @effect_type = effect_type
        @identifier = identifier
      end

      def call(*args)
        consumer = consumers[effect_type].new(*args, identifier: identifier)
        fiber = ::Fiber.new { yield }

        result = fiber.resume

        fiber_result = loop do
          break result unless fiber.alive?

          if result.is_a?(Effect) && handle?(consumer, result)
            result = fiber.resume(consumer.public_send(result.name, *result.payload))
          else
            result = fiber.resume(Effects.yield(result))
          end
        end

        consumer.output(fiber_result)
      end

      def handle?(consumer, effect)
        effect.type.equal?(effect_type) && effect.identifier.equal?(consumer.identifier)
      end
    end
  end
end
