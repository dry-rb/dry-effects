# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Reader < Provider[:reader]
        def self.handle_method(scope, as: Undefined, **)
          Undefined.default(as) { :"with_#{scope}" }
        end

        Any = Object.new.tap { |any|
          def any.===(_)
            true
          end
        }.freeze

        include Dry::Equalizer(:scope, :state)

        attr_reader :state

        param :scope

        option :type, as: :state_type, default: -> { Any }

        def initialize(*)
          super

          @state = Undefined
        end

        def read
          state
        end

        def call(stack, state)
          case state
          when state_type
            @state = state
            super(stack)
          else
            raise Errors::InvalidValueError.new(state, scope)
          end
        end

        def represent
          if Undefined.equal?(state)
            "#{type}[#{scope} unset]"
          else
            "#{type}[#{scope} set]"
          end
        end

        def provide?(effect)
          effect.type.equal?(:state) && effect.name.equal?(:read) && scope.equal?(effect.scope)
        end
      end
    end
  end
end
