# frozen_string_literal: true

module Dry
  module Effects
    module Providers
      class Implicit < Provider[:implicit]
        def self.mixin(identifier, lookup_map: EMPTY_HASH, **kwargs)
          super(identifier: identifier, static: lookup_map, **kwargs)
        end

        include Dry::Equalizer(:identifier, :dictionary)

        param :dynamic, default: -> { EMPTY_HASH }

        option :static, default: -> { EMPTY_HASH }

        option :dictionary, default: -> { static.empty? ? dynamic : static.merge(dynamic) }

        def implicit(arg)
          dictionary.fetch(arg.class)
        end

        def provide?(effect)
          super && dictionary.key?(effect.payload[0].class)
        end
      end
    end
  end
end

