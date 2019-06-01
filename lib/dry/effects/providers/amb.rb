require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Amb < Provider[:amb]
        def initialize(*)
          super
          @value = false
        end

        def get
          @value
        end

        def call
          first = yield
          @value = true
          [first, yield]
        end
      end
    end
  end
end
