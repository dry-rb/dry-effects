# frozen_string_literal: true

require "fiber"
require "dry/effects/initializer"
require "dry/effects/effect"
require "dry/effects/errors"
require "dry/effects/stack"
require "dry/effects/instructions/raise"

module Dry
  module Effects
    # Stack frame
    #
    # @api private
    class Frame
      class << self
        # Accessing current stack of effect handlers.
        # It is inherently thread/fiber-local.
        #
        # @return [Stack]
        # @api private
        def stack
          ::Thread.current[:dry_effects_stack] ||= Stack.new
        end

        # @param [Stack] stack
        # @api private
        def stack=(stack)
          ::Thread.current[:dry_effects_stack] = stack
        end

        # Spawn a new fiber with a stack of effect handlers
        #
        # @param [Stack] stack
        # @api private
        def spawn_fiber(stack)
          fiber = ::Fiber.new do
            self.stack = stack
            yield
          end
          result = fiber.resume

          loop do
            error = false
            break result unless fiber.alive?

            provided = stack.(result) do
              ::Dry::Effects.yield(result) do |_, e|
                error = true
                e
              end
            end

            result =
              if error
                raise_in_fiber(fiber, provided)
              else
                fiber.resume(provided)
              end
          end
        end

        private

        if RUBY_VERSION >= "2.7"
          # @api private
          def raise_in_fiber(fiber, error)
            fiber.raise(error)
          end
        else
          # @api private
          def raise_in_fiber(fiber, error)
            fiber.resume(Instructions.Raise(error))
          end
        end
      end

      extend Initializer

      # @!attribute provider
      #   @return [Provider] Effects provider
      param :provider

      # Add new handler to the current stack
      # and run the given block
      #
      # @param [Array<Object>] args Handler arguments
      # @param [Proc] block Program to run
      # @api private
      def call(*args, &block)
        stack = Frame.stack
        prov = provider.dup
        was_empty = stack.empty?

        prov.(*args) do
          if was_empty
            stack.push(prov) do
              Frame.spawn_fiber(stack, &block)
            end
          else
            stack.push(prov, &block)
          end
        end
      end
    end
  end
end
