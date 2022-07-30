# frozen_string_literal: true

require "concurrent/map"
require "dry/effects/inflector"

module Dry
  module Effects
    class Halt < StandardError
      extend Core::ClassAttributes

      @constants = ::Concurrent::Map.new

      def self.[](key)
        @constants.fetch_or_store(key) do
          klass = ::Class.new(Halt)
          const_set(Inflector.camelize(key), klass)
        end
      end

      attr_reader :payload

      def initialize(payload = Undefined)
        super(EMPTY_STRING)
        @payload = payload
      end
    end
  end
end
