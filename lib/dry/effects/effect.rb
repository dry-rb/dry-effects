# frozen_string_literal: true

require 'dry/equalizer'
require 'dry/effects/initializer'

module Dry
  module Effects
    class Effect
      extend Initializer

      option :type

      option :name, default: -> { type }

      option :identifier, default: -> { Undefined }

      option :payload, default: -> { EMPTY_ARRAY }

      include ::Dry::Equalizer(:type, :name, :identifier, :payload)

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
