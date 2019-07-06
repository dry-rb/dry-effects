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
      rescue FiberError
        if block_given?
          yield
        else
          raise Errors::UnhandledEffect, effect
        end
      end
    end
  end
end

require 'dry/effects/handler'
require 'dry/effects/all'
