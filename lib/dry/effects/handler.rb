module Dry
  module Effects
    class Handler
      attr_reader :consumer

      def initialize(consumer)
        @consumer = consumer
      end

      def call(*args)
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
