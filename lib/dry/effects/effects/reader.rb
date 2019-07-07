# frozen_string_literal: true

require 'dry/effects/effects/state'

module Dry
  module Effects
    module Effects
      class Reader < State
        def initialize(scope, writer: false, **opts)
          super
        end
      end
    end
  end
end
