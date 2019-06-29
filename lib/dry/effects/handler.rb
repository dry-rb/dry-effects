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
        def current_stack
          ::Thread.current[:dry_effects_stack] ||= Stack.new
        end

        def use_stack(stack, &block)
          prev = current
          ::Thread.current[:dry_effects_stack] = stack
          stack.with_stack(&block)
        ensure
          ::Thread.current[:dry_effects_stack] = prev
        end

        def set_stack(stack)
          ::Thread.current[:dry_effects_stack] = stack
        end

        def spawn_fiber(stack)
          fiber = ::Fiber.new do
            set_stack(stack)
            yield
          end
          result = fiber.resume

          loop do
            break result unless fiber.alive?

            provided = stack.(result) do
              ::Dry::Effects.yield(result)
            end

            result = fiber.resume(provided)
          end
        end
      end

      extend Initializer

      param :provider_type, default: -> { Undefined }

      param :provider_args, default: -> { EMPTY_ARRAY }

      def call(initial = Undefined, &block)
        if Undefined.equal?(initial)
          provider = provider_type.new(*provider_args)
        else
          provider = provider_type.new(initial, *provider_args)
        end

        stack = Handler.current_stack

        if stack.empty?
          stack.push(provider) { Handler.spawn_fiber(stack, &block) }
        else
          stack.push(provider, &block)
        end
      end
    end
  end
end
