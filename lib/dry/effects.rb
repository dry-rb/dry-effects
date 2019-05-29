require 'dry/core/constants'
require 'dry/effects/version'
require 'dry/effects/container'
require 'dry/effects/errors'

module Dry
  module Effects
    include Core::Constants

    class Error < StandardError; end

    @effects = Container.new
    @providers = Container.new

    FAIL = ::Object.new.freeze
    READ_ERROR = ::Object.new.freeze

    class << self
      attr_reader :effects, :providers

      def [](effect)
        if effect.is_a?(::Symbol)
          type = effect
          identifier = Undefined
        else
          type, identifier = effect.to_a.first
        end

        effects[type].new(identifier)
      end

      def yield(effect)
        result = ::Fiber.yield(effect)

        if FAIL.equal?(result)
          raise ::Fiber.yield(READ_ERROR)
        else
          result
        end
      rescue FiberError
        raise Errors::UnhandledEffect.new(effect)
      end
    end
  end
end

require 'dry/effects/handler'
require 'dry/effects/all'
