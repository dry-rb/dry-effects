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

      param :provider_type, default: -> { Undefined }

      param :provider_args, default: -> { EMPTY_ARRAY }

      def call(initial = Undefined, &block)
        if Undefined.equal?(initial)
          provider = provider_type.new(*provider_args)
        elsif provider_args.empty?
          provider = provider_type.new(initial, EMPTY_HASH)
        else
          provider = provider_type.new(initial, *provider_args)
        end

        stack = Handler.stack

        if stack.empty?
          stack.push(provider) { Handler.spawn_fiber(stack, &block) }
        else
          stack.push(provider, &block)
        end
      end
    end
  end
end
