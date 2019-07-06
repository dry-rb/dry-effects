# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Implicit < Provider[:implicit]
        include Dry::Equalizer(:name, :static, :dictionary)

        param :dependency

        param :static, default: -> { EMPTY_HASH }

        attr_reader :dictionary

        def implicit(arg)
          dictionary.fetch(arg.class)
        end

        def call(_stack, dynamic = Undefined)
          if Undefined.equal?(dynamic) || dynamic.empty?
            @dictionary = static
          else
            @dictionary = static.merge(dynamic)
          end

          super
        end

        def provide?(effect)
          super &&
            dependency.equal?(effect.dependency) &&
            dictionary.key?(effect.payload[0].class)
        end
      end
    end
  end
end
