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

        provider_type = Effects.providers[type]

        handler = new(provider_type, identifier)

        Module.new do
          define_method(as) { |init = Undefined, &block| handler.(init, &block) }
        end
      end

      extend Initializer

      param :provider_type, default: -> { Undefined }

      param :identifier, default: -> { Undefined }

      def call(initial = Undefined, &block)
        if Undefined.equal?(initial)
          provider = provider_type.new(identifier: identifier)
        else
          provider = provider_type.new(initial, identifier: identifier)
        end

        stack = Stack.current

        if stack.empty?
          stack.push(provider) do
            fiber = ::Fiber.new(&block)
            result = fiber.resume

            loop do
              break result unless fiber.alive?

              result = fiber.resume(stack.(result))
            end
          end
        else
          stack.push(provider, &block)
        end
      end
    end
  end
end
