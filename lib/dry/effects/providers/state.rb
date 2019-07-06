# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class State < Provider[:state]
        include Dry::Equalizer(:scope, :state)

        attr_reader :state

        param :scope

        def read
          state
        end

        def write(value)
          @state = value
        end

        def call(_stack, state = @state.dup)
          @state = state
          r = super
          [@state, r]
        end

        def represent
          "#{super}(#{state})"
        end

        def provide?(effect)
          super && scope.equal?(effect.scope)
        end
      end
    end
  end
end
