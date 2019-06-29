# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Env < Provider[:env]
        param :values, default: -> { EMPTY_HASH }

        option :overridable, default: -> { false }

        def env(key)
          values.fetch(key) do
            if key.is_a?(::String)
              ::ENV.fetch(key)
            else
              raise ::KeyError.new(key)
            end
          end
        end

        def provide?(effect)
          super && key?(effect.payload[0])
        end

        def key?(key)
          values.key?(key) || key.is_a?(::String) && ::ENV.key?(key)
        end
      end
    end
  end
end
