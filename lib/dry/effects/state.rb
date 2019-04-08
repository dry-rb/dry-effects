require 'fiber'

module Dry
  module Effects
    module State
      class Effects
        def read
          Fiber.yield(:read)
        end

        def write(value)
          Fiber.yield(:write, value)
        end
      end

      class Handler
        def call(initial_state)
          fiber = ::Fiber.new { yield }
          state = initial_state

          result = fiber.resume

          fiber_result = loop do
            break result unless fiber.alive?

            effect, *payload = result

            case effect
            when :read
              result = fiber.resume(state)
            when :write
              state = payload[0]
              result = fiber.resume
            end
          end

          [state, fiber_result]
        end
      end
    end
  end
end
