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
          process_instruction(result)
        else
          result
        end
      rescue FiberError
        if block_given?
          yield
        else
          raise Errors::UnhandledEffect.new(effect)
        end
      end

      def process_instruction(instruction)
        case instruction
        when Instructions::Raise
          raise instruction.error
        else
          raise ArgumentError, "Unknown instruction: #{instruction.inspect}"
        end
      end
    end
  end
end

require 'dry/effects/handler'
require 'dry/effects/all'
