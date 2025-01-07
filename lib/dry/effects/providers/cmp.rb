# frozen_string_literal: true

module Dry
  module Effects
    module Providers
      class Cmp < Provider[:cmp]
        include ::Dry::Equalizer(:id, :value, inspect: false)

        attr_reader :value

        param :id

        def get = value

        # Yield the block with the handler installed
        #
        # @return [Array(Any, Any)]
        # @api private
        def call(value = Undefined)
          if Undefined.equal?(value)
            @value = false
            first = yield
            @value = true
            [first, yield]
          else
            @value = value
            yield
          end
        end

        # @param [Effect] effect
        # @return [Boolean]
        # @api public
        def provide?(effect) = super && id.equal?(effect.id)

        # @return [String]
        # @api public
        def represent = "cmp[#{id}=#{@value}]"
      end
    end
  end
end
