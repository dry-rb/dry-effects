# frozen_string_literal: true

require 'dry/equalizer'
require 'dry/effects/initializer'

module Dry
  module Effects
    class Effect
      extend Initializer

      include ::Dry::Equalizer(:type, :name, :payload)

      option :type

      option :name, default: -> { type }

      option :payload, default: -> { EMPTY_ARRAY }

      def payload(*payload)
        if payload.empty?
          @payload
        else
          with(payload: payload)
        end
      end
      alias_method :call, :payload
    end
  end
end
