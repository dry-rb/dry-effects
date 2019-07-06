# frozen_string_literal: true

require 'dry/effects/initializer'
require 'dry/effects/provider/class_interface'

module Dry
  module Effects
    class Provider
      extend Initializer
      extend ClassInterface

      def call(_stack)
        yield
      end

      def represent
        type.to_s
      end

      def type
        self.class.type
      end

      def provide?(effect)
        type.equal?(effect.type)
      end
    end
  end
end
