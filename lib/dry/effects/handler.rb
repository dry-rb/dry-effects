# frozen_string_literal: true

require 'fiber'
require 'dry/effects/initializer'
require 'dry/effects/effect'
require 'dry/effects/errors'
require 'dry/effects/stack'

module Dry
  module Effects
    class Handler
      class << self
        def stack
          ::Thread.current[:dry_effects_stack] ||= Stack.new
        end

        def stack=(stack)
          ::Thread.current[:dry_effects_stack] = stack
        end

        def spawn_fiber(stack)
          fiber = ::Fiber.new do
            self.stack = stack
            yield
          end
          result = fiber.resume

          loop do
            break result unless fiber.alive?

            provided = stack.(result) { ::Dry::Effects.yield(result) }

            result = fiber.resume(provided)
          end
        end
      end

      extend Initializer

      param :provider

      def call(init = Undefined, &block)
        stack = Handler.stack

        if stack.empty?
          stack.push(provider.dup, init) { Handler.spawn_fiber(stack, &block) }
        else
          stack.push(provider.dup, init, &block)
        end
      end
    end
  end
end
