# frozen_string_literal: true

module Dry
  module Effects
    module Instructions
      def self.Raise(error)
        Raise.new(error)
      end

      def self.Execute(&block)
        Execute.new(block)
      end
    end
  end
end
