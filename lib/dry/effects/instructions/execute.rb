# frozen_string_literal: true

module Dry
  module Effects
    module Instructions
      class Execute < Instruction
        attr_reader :block

        def initialize(block)
          super()
          @block = block
        end

        def call
          block.call
        end
      end
    end
  end
end
