module Dry
  module Effects
    class Consumer
      attr_reader :identifier

      def initialize(identifier:)
        @identifier = identifier
      end
    end
  end
end
