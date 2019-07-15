# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class CurrentTime < Provider[:current_time]
        include Dry::Equalizer(:fixed, :round)

        option :fixed, default: -> { true }

        option :round, default: -> { Undefined }

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

        def current_time(round_to: Undefined)
          t = fixed? ? time : Undefined.default(time) { ::Time.now }
          round = Undefined.default(round_to) { self.round }

          if Undefined.equal?(round)
            t
          else
            t.round(round)
          end
        end
      end
    end
  end
end
