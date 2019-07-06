# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Reader < Provider[:reader]
        include Dry::Equalizer(:scope, :state)

        attr_reader :state

        param :scope

        def read
          state
        end

        def call(stack, state)
          @state = state
          super(stack)
        end

        def represent
          "#{super}(#{state})"
        end

        def provide?(effect)
          effect.type.equal?(:state) && scope.equal?(effect.scope)
        end
      end
    end
  end
end
