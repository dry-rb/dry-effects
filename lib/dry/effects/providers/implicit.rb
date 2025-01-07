# frozen_string_literal: true

module Dry
  module Effects
    module Providers
      class Implicit < Provider[:implicit]
        include ::Dry::Equalizer(:name, :static, :dictionary, inspect: false)

        param :dependency

        param :static, default: -> { EMPTY_HASH }

        attr_reader :dictionary

        def implicit(arg) = dictionary.fetch(arg.class)

        # Yield the block with the handler installed
        #
        # @api private
        def call(dynamic = EMPTY_HASH)
          if dynamic.empty?
            @dictionary = static
          else
            @dictionary = static.merge(dynamic)
          end

          yield
        end

        # @param [Effect] effect
        # @return [Boolean]
        # @api public
        def provide?(effect)
          super &&
            dependency.equal?(effect.dependency) &&
            dictionary.key?(effect.payload[0].class)
        end
      end
    end
  end
end
