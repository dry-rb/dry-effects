# frozen_string_literal: true

require 'dry/equalizer'
require 'dry/effects/initializer'

module Dry
  module Effects
    class Effect
      extend Initializer

      include ::Dry::Equalizer(:type, :name, :payload, :keywords)

      option :type

      option :name, default: -> { type }

      option :payload, default: -> { EMPTY_ARRAY }

      option :keywords, default: -> { EMPTY_HASH }

      def payload(*payload)
        if payload.empty?
          @payload
        else
          with(payload: payload)
        end
      end

      def keywords(**keywords)
        if keywords.empty?
          @keywords
        else
          with(keywords: @keywords.merge(keywords))
        end
      end

      def call(*args, **kwargs)
        if args.empty?
          if kwargs.empty?
            self
          else
            keywords(**kwargs)
          end
        else
          with(payload: args, keywords: @keywords.merge(kwargs))
        end
      end
    end
  end
end
