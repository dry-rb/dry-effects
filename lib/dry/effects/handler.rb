require 'fiber'
require 'dry/effects/initializer'
require 'dry/effects/effect'
require 'dry/effects/errors'

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

      def call(*args)
        provider = registry[effect_type].new(*args, identifier: identifier)

        provider.() do
          fiber = ::Fiber.new { yield }
          result = fiber.resume

          fiber_result = loop do
            break result unless fiber.alive?

            if result.is_a?(Effect) && handle?(provider, result)
              result = fiber.resume(provider.public_send(result.name, *result.payload))
            else
              result = fiber.resume(Effects.yield(result))
            end
          end
        end
      end

      def handle?(provider, effect)
        effect.type.equal?(effect_type) && effect.identifier.equal?(provider.identifier)
      end
    end
  end
end
