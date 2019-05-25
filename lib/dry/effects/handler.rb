require 'fiber'
require 'dry/effects/effect'

module Dry
  module Effects
    class Handler
      def self.[](effect, as:)
        consumer = Effects.consumers[effect]
        handler = new(consumer)
        Module.new do
          define_method(as) { |*args, &block| handler.(*args, &block) }
        end
      end

      attr_reader :consumer_factory

      def initialize(consumer_factory)
        @consumer_factory = consumer_factory
      end

      def call(*args)
        consumer = consumer_factory.new(*args)
        fiber = ::Fiber.new { yield }

        result = fiber.resume

        fiber_result = loop do
          break result unless fiber.alive?

          if result.is_a?(Effect) && consumer.respond_to?(result.name)
            result = fiber.resume(consumer.public_send(result.name, *result.payload))
          else
            result = fiber.resume(Fiber.yield(result))
          end
        end

        consumer.output(fiber_result)
      end
    end
  end
end
