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

      param :provider_type

      param :curried_args, default: -> { EMPTY_ARRAY }

      param :curried_kwargs, default: -> { EMPTY_HASH }

      def call(args = EMPTY_ARRAY, kwargs = EMPTY_HASH, &block)
        merged_kwargs = curried_kwargs.merge(kwargs)
        unapplied = unapplied(args)

        provider =
          if unapplied.zero?
            if merged_kwargs.empty?
              provider_type.new(*curried_args, *args)
            else
              provider_type.new(*curried_args, *args, merged_kwargs)
            end
          elsif merged_kwargs.empty? && !provider_type.options?
            provider_type.new(*curried_args, *args)
          elsif provider_type.options?
            provider_type.new(*curried_args, *args, merged_kwargs, EMPTY_HASH)
          else
            provider_type.new(*curried_args, *args, merged_kwargs)
          end

        stack = Handler.stack

        if stack.empty?
          stack.push(provider) { Handler.spawn_fiber(stack, &block) }
        else
          stack.push(provider, &block)
        end
      end

      def unapplied(args)
        provider_type.params_arity - args.size - curried_args.size
      end
    end
  end
end
