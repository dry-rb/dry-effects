# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Env < Provider[:env]
        include Dry::Equalizer(:values)

        attr_reader :values

        option :overridable, default: -> { false }

        def read(key)
          values.fetch(key) do
            if key.is_a?(::String)
              ::ENV.fetch(key)
            else
              raise ::KeyError.new(key)
            end
          end
        end

        def call(_stack, values = Undefined)
          @values = Undefined.default(values, EMPTY_HASH)
          super
        end

        def provide?(effect)
          super && effect.name.equal?(:read) && key?(effect.payload[0])
        end

        def key?(key)
          values.key?(key) || key.is_a?(::String) && ::ENV.key?(key)
        end
      end
    end
  end
end
