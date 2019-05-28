require 'dry/effects/initializer'

module Dry
  module Effects
    class Provider
      extend Initializer

      option :identifier, type: -> id {
        Undefined.default(id) { raise ArgumentError, "No identifier given" }
      }

      def call
        yield
      end

      def reuse_stack?
        false
      end
    end
  end
end
