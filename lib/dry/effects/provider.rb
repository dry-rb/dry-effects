module Dry
  module Effects
    class Provider
      attr_reader :identifier

      def initialize(identifier:)
        @identifier = Undefined.default(identifier) do
          raise ArgumentError, "No identifier given"
        end
      end
    end
  end
end
