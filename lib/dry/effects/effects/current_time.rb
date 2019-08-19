# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class CurrentTime < ::Module
        CurrentTime = Effect.new(type: :current_time)

        def initialize(round: Undefined)
          outer_round = round

          module_eval do
            define_method(:current_time) do |round: Undefined, refresh: false|
              round_to = Undefined.coalesce(outer_round, round)

              if Undefined.equal?(round_to) && refresh.equal?(false)
                effect = CurrentTime
              else
                effect = CurrentTime.payload(round_to: round_to, refresh: refresh)
              end

              ::Dry::Effects.yield(effect)
            end
          end
        end
      end
    end
  end
end
