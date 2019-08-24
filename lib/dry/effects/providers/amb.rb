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

        def provide?(effect)
          super && id.equal?(effect.id)
        end

        def represent
          "amb[#{id}=#{@value}]"
        end
      end
    end
  end
end
