require 'fiber'
require 'dry/effects/initializer'
require 'dry/effects/effect'
require 'dry/effects/errors'
require 'dry/effects/stack'

module Dry
  module Effects
    class Handler
      def self.[](effect = Undefined, as:, **kwargs)
        if Undefined.equal?(effect)
          type, identifier = kwargs.to_a.first
        else
          type, identifier = effect, Undefined
        end

        handler = new(type, identifier)

        Module.new do
          define_method(as) { |*args, &block| handler.(*args, &block) }
        end
      end

      extend Initializer

      param :effect_type

      param :identifier, default: -> { Undefined }

      option :registry, default: -> { Effects.providers }

      def call(*args, &block)
        provider = registry[effect_type].new(*args, identifier: identifier)

        stack = Stack.current

        if stack.empty?
          stack.push(effect_type, provider) do
            fiber = ::Fiber.new(&block)
            result = fiber.resume

            loop do
              break result unless fiber.alive?

              result = fiber.resume(stack.(result))
            end
          end
        else
          stack.push(effect_type, provider, &block)
        end
      end
    end
  end
end
