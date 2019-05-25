require 'fiber'
require 'dry/effects/effect'

module Dry
  module Effects
    class Handler
      def self.[](effect, as:)
        handler = new(effect)
        Module.new do
          define_method(as) { |*args, &block| handler.(*args, &block) }
        end
      end

      attr_reader :consumers, :effect_type, :identifier

      def initialize(effect_type, identifier: :default, consumers: Effects.consumers)
        @consumers = consumers
        @effect_type = effect_type
        @identifier = identifier
      end

      def call(*args)
        consumer = consumers[effect_type].new(*args, identifier: :identifier)
        fiber = ::Fiber.new { yield }

        result = fiber.resume

        fiber_result = loop do
          break result unless fiber.alive?

          if result.is_a?(Effect) && handle?(result)
            result = fiber.resume(consumer.public_send(result.name, *result.payload))
          else
            result = fiber.resume(Fiber.yield(result))
          end
        end

        consumer.output(fiber_result)
      end

      def handle?(effect)
        effect.type.equal?(effect_type) && effect.identifier.equal?(identifier)
      end
    end
  end
end
