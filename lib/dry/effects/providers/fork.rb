# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Fork < Provider[:fork]
        attr_reader :stack

        def fork
          -> &cont { Handler.spawn_fiber(stack.dup, &cont) }
        end

        def call(stack)
          @stack = stack
          super
        end
      end
    end
  end
end
