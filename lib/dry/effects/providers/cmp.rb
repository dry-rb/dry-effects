# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Cmp < Provider[:cmp]
        include Dry::Equalizer(:id, :value)

        attr_reader :value

        param :id

        def get
          value
        end

        # Yield the block with the handler installed
        #
        # @return [Array(Any, Any)]
        # @api private
        def call(stack, value = Undefined)
          if Undefined.equal?(value)
            @value = false
            first = super(stack)
            @value = true
            [first, super(stack)]
          else
            @value = value
            super(stack)
          end
        end

        # @param [Effect] effect
        # @return [Boolean]
        # @api public
        def provide?(effect)
          super && id.equal?(effect.id)
        end

        # @return [String]
        # @api public
        def represent
          "cmp[#{id}=#{@value}]"
        end
      end
    end
  end
end
