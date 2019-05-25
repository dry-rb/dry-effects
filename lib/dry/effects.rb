require "dry/core/constants"
require "dry/effects/version"
require "dry/effects/container"

module Dry
  module Effects
    include Core::Constants

    class Error < StandardError; end

    @effects = Container.new
    @consumers = Container.new

    class << self
      attr_reader :effects, :consumers
    end
  end
end

require "dry/effects/handler"
