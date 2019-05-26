require 'dry/equalizer'
require 'dry/effects/initializer'

module Dry
  module Effects
    class Effect
      extend Initializer

      option :type

      option :name, default: -> { type }

      option :identifier

      option :payload, default: -> { EMPTY_ARRAY }

      include ::Dry::Equalizer(:type, :name, :identifier, :payload)

      def initialize(*)
        super
        if Undefined.equal?(identifier)
          raise ArgumentError, "No identifier provided for a #{type} effect (#{name})"
        end
      end

      def payload(*payload)
        if payload.empty?
          @payload
        else
          with(payload: payload)
        end
      end

      def with_identifier(identifier)
        with(identifier: identifier)
      end
    end
  end
end
