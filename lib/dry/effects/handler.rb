require 'fiber'

module Dry
  module Effects
    class Handler
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

          result = fiber.resume(consumer.public_send(*result))
        end

        consumer.output(fiber_result)
      end
    end
  end
end
