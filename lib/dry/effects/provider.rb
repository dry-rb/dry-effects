require 'dry/effects/initializer'
require 'dry/effects/provider/class_interface'

module Dry
  module Effects
    class Provider
      extend Initializer
      extend ClassInterface
      include Dry::Equalizer(:identifier)

      option :identifier, type: -> id {
        Undefined.default(id) { raise ArgumentError, "No identifier given" }
      }

      def call
        yield
      end

      def represent
        "#{type}##{identifier}"
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
