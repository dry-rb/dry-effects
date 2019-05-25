module Dry
  module Effects
    class Consumer
      attr_reader :identifier

      def initialize(identifier:)
        @identifier = Undefined.default(identifier) do
          raise ArgumentError, "No identifier given"
        end
      end
    end
  end
end
