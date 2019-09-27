# frozen_string_literal: true

require 'dry/effects/initializer'
require 'dry/effects/provider/class_interface'

module Dry
  module Effects
    # Base class for effect providers
    #
    # @api private
    class Provider
      extend Initializer
      extend ClassInterface

      # yield the block with the handler installed
      #
      # @api private
      def call(_stack)
        yield
      end

      # Effect-specific representation of the provider
      #
      # @return [String]
      # @api public
      def represent
        type.to_s
      end

      # Effect type
      #
      # @return [Symbol]
      # @api public
      def type
        self.class.type
      end

      # Whether the effect can be handled?
      #
      # @param [Effect] effect
      # @return [Boolean]
      # @api public
      def provide?(effect)
        type.equal?(effect.type)
      end
    end
  end
end
