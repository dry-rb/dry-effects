# frozen_string_literal: true

require "dry/core"
require "dry/effects/version"
require "dry/effects/container"
require "dry/effects/errors"
require "dry/effects/instructions/raise"

module Dry
  module Effects
    include Core::Constants

    class Error < StandardError; end

    @effects = Container.new
    @providers = Container.new

    class << self
      attr_reader :effects, :providers

      # Handle an effect.
      # If no handler is present in the stack it will either
      # raise an exception and yield a block if given.
      # It is not recommended to build effects manually, hence
      # this method shouldn't be used often.
      #
      # @example getting current user with yield
      #
      #   require 'dry/effects/effects/reader'
      #   extend Dry::Effects::Constructors
      #   Dry::Effects.yield(Read(:current_user))
      #
      # @param [Effect] effect
      # @return [Object] Result value is determined by effect type
      # @api public
      def yield(effect)
        result = ::Fiber.yield(effect)

        if result.is_a?(Instruction)
          result.()
        else
          result
        end
      rescue ::FiberError => e
        if block_given?
          yield(effect, e)
        else
          raise Errors::UnhandledEffectError, effect
        end
      end

      # Build a handler.
      # Normally, handlers are built via mixins.
      # This method is useful for demonstration purposes.
      #
      # @example providing current user
      #
      #   Dry::Effects[:reader, :current_user].(User.new) do
      #     code_using_current_user.()
      #   end
      #
      # @param [Array<Object>] args Handler parameters
      # @return [Handler]
      # @api public
      def [](...)
        Handler.new(...)
      end
    end
  end
end

require "dry/effects/all"
require "dry/effects/extensions"
