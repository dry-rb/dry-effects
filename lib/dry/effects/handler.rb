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

          if consumer.respond_to?(result[0])
            result = fiber.resume(consumer.public_send(*result))
          else
            result = fiber.resume(Fiber.yield(result))
          end
        end

        consumer.output(fiber_result)
      end
    end
  end
end