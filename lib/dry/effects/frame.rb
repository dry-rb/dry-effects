# frozen_string_literal: true

require 'fiber'
require 'dry/effects/initializer'
require 'dry/effects/effect'
require 'dry/effects/errors'
require 'dry/effects/stack'
require 'dry/effects/instructions/raise'

module Dry
  module Effects
    class Frame
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

            provided = stack.(result) do
              ::Dry::Effects.yield(result) do |_, error|
                Instructions.Raise(error)
              end
            end

            result = fiber.resume(provided)
          end
        end
      end

      extend Initializer

      param :provider

      def call(args = EMPTY_ARRAY, &block)
        stack = Frame.stack

        if stack.empty?
          stack.push(provider.dup, args) { Frame.spawn_fiber(stack, &block) }
        else
          stack.push(provider.dup, args, &block)
        end
      end
    end
  end
end
