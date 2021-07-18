# frozen_string_literal: true

require "dry/effects/instruction"

module Dry
  module Effects
    module Instructions
      class Execute < Instruction
        attr_reader :block

        def initialize(block)
          @block = block
        end

        def call
          block.call
        end
      end

      def self.Execute(&block)
        Execute.new(block)
      end
    end
  end
end
