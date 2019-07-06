# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class CurrentTime < Provider[:current_time]
        include Dry::Equalizer(:fixed)

        option :fixed, default: -> { true }

        alias_method :fixed?, :fixed

        attr_reader :time

        def call(stack, time = Undefined)
          if fixed?
            @time = Undefined.default(time) { ::Time.now }
          else
            @time = time
          end
          super(stack)
        end

        def current_time
          if fixed?
            time
          else
            Undefined.default(time) { ::Time.now }
          end
        end
      end
    end
  end
end
