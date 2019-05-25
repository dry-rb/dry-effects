require 'dry/equalizer'

module Dry
  module Effects
    class Effect
      attr_reader :type, :name, :identifier, :payload

      include ::Dry::Equalizer(:type, :name, :identifier, :payload)

      def initialize(type, name, identifier = :default, payload = EMPTY_ARRAY)
        @type = type
        @name = name
        @identifier = identifier
        @payload = payload
      end

      def with(*payload)
        self.class.new(type, name, identifier, payload)
      end
    end
  end
end
