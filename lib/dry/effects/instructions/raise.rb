# frozen_string_literal: true

module Dry
  module Effects
    module Instructions
      class Raise < Instruction
        attr_reader :error

        def initialize(error)
          super()
          @error = error
        end

        def call
          raise error
        end
      end
    end
  end
end
