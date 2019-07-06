# frozen_string_literal: true

require 'dry/effects/effects/state'

module Dry
  module Effects
    module Effects
      class Reader < State
        def initialize(scope, default: Undefined, writer: false)
          super
        end
      end
    end
  end
end
