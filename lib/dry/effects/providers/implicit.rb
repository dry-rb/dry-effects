# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Implicit < Provider[:implicit]
        include Dry::Equalizer(:name, :dictionary)

        param :dependency

        param :static, default: -> { EMPTY_HASH }

        param :dynamic, default: -> { EMPTY_HASH }

        option :dictionary, default: -> { static.empty? ? dynamic : static.merge(dynamic) }

        def implicit(arg)
          dictionary.fetch(arg.class)
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
