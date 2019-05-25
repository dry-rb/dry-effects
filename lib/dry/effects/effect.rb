require 'dry/equalizer'

module Dry
  module Effects
    class Effect
      attr_reader :scope, :name, :key, :payload

      include ::Dry::Equalizer(:scope, :name, :key, :payload)

      def initialize(scope, name, key = Undefined, payload = EMPTY_ARRAY)
        @scope = scope
        @name = name
        @key = key
        @payload = payload
      end

      def with(*payload)
        self.class.new(scope, name, key, payload)
      end
    end
  end
end
