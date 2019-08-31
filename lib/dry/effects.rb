# frozen_string_literal: true

require 'dry/core/constants'
require 'dry/effects/version'
require 'dry/effects/container'
require 'dry/effects/errors'
require 'dry/effects/instructions/raise'

module Dry
  module Effects
    include Core::Constants

    class Error < StandardError; end

    @effects = Container.new
    @providers = Container.new

    class << self
      attr_reader :effects, :providers

      def yield(effect)
        result = ::Fiber.yield(effect)

        if result.is_a?(Instruction)
          result.()
        else
          result
        end
      rescue FiberError => e
        if block_given?
          yield(effect, e)
        else
          raise Errors::UnhandledEffectError, effect
        end
      end

      def [](*args)
        Handler.new(*args)
      end
    end
  end
end

require 'dry/effects/all'
require 'dry/effects/extensions'
