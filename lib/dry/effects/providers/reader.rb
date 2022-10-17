# frozen_string_literal: true

module Dry
  module Effects
    module Providers
      class Reader < Provider[:reader]
        def self.handle_method(scope, as: Undefined, **)
          Undefined.default(as) { :"with_#{scope}" }
        end

        Any = ::Object.new.tap { |any|
          def any.===(_)
            true
          end
        }.freeze

        include ::Dry::Equalizer(:scope, :state, inspect: false)

        attr_reader :state

        param :scope

        option :type, as: :state_type, default: -> { Any }

        def initialize(*, **)
          super

          @state = Undefined
        end

        def read
          state
        end

        # Yield the block with the handler installed
        #
        # @api private
        def call(state)
          case state
          when state_type
            @state = state
            yield
          else
            raise Errors::InvalidValueError.new(state, scope)
          end
        end

        # @return [String]
        # @api public
        def represent
          if Undefined.equal?(state)
            "#{type}[#{scope} not set]"
          else
            "#{type}[#{scope} set]"
          end
        end

        # @return [Boolean]
        # @api public
        def provide?(effect)
          effect.type.equal?(:state) && effect.name.equal?(:read) && scope.equal?(effect.scope)
        end
      end
    end
  end
end
