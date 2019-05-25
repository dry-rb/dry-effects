require 'dry/core/constants'
require 'dry/effects/version'
require 'dry/effects/container'

module Dry
  module Effects
    include Core::Constants

    class Error < StandardError; end

    @effects = Container.new
    @consumers = Container.new

    class << self
      attr_reader :effects, :consumers

      def [](effect)
        effects[effect]
      end

      def yield(effect)
        Fiber.yield(effect)
      end
    end
  end
end

require 'dry/effects/handler'
require 'dry/effects/all'
