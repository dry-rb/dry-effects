# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class CurrentTime < ::Module
        CurrentTime = Effect.new(type: :current_time)

        def initialize(round: Undefined)
          get = CurrentTime.payload(round_to: round)

          module_eval do
            define_method(:current_time) do |round: Undefined|
              if Undefined.equal?(round)
                ::Dry::Effects.yield(get)
              else
                ::Dry::Effects.yield(get.payload(round_to: round))
              end
            end
          end
        end
      end
    end
  end
end
