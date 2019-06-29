# frozen_string_literal: true

require 'dry/effects/initializer'
require 'dry/effects/provider/class_interface'

module Dry
  module Effects
    class Provider
      extend Initializer
      extend ClassInterface
      include Dry::Equalizer(:identifier)

      option :identifier, default: -> { Undefined }

      def call(_stack, _index)
        yield
      end

      def represent
        if Undefined.equal?(identifier)
          type.to_s
        else
          "#{type}##{identifier}"
        end
      end

      def type
        self.class.type
      end

      def provide?(effect)
        type.equal?(effect.type) && identifier.equal?(effect.identifier)
      end
    end
  end
end
