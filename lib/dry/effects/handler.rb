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

      def call(*args)
        provider = registry[effect_type].new(*args, identifier: identifier)

        stack = Stack.current

        if provider.reuse_stack? && !stack.empty?
          stack.push(effect_type, provider) do
            yield
          end
        else
          stack.push(effect_type, provider) do
            fiber = ::Fiber.new { yield }
            result = fiber.resume
            error = nil

            fiber_result = loop do
              break result unless fiber.alive?

              begin
                if (provider = stack.provider(effect_type, result))
                  value = provider.public_send(result.name, *result.payload)
                elsif READ_ERROR.equal?(result)
                  value = error
                else
                  value = Effects.yield(result)
                end
              rescue Exception => error
                value = FAIL
              end

              result = fiber.resume(value)
            end
          end
        end
      end
    end
  end
end
