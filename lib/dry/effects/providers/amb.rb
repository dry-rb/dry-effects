# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Amb < Provider[:amb]
        include Dry::Equalizer(:id, :value)

        attr_reader :value

        param :id

        def get
          value
        end

        def call(_, value = Undefined)
          @value = Undefined.default(value, false)

          if @value.equal?(false)
            first = yield
            @value = true
            [first, yield]
          else
            [first, yield]
          end
        end

        def provide?(effect)
          super && id.equal?(effect.id)
        end
      end
    end
  end
end
