# frozen_string_literal: true

require 'dry/effects/effect'
require 'dry/effects/constructors'

module Dry
  module Effects
    module Effects
      class CurrentTime < ::Module
        CurrentTime = Effect.new(type: :current_time)

        Constructors.register(:CurrentTime) do |**kwargs|
          if kwargs.empty?
            CurrentTime
          else
            CurrentTime.payload(kwargs)
          end
        end

        def initialize(options = EMPTY_HASH)
          module_eval do
            define_method(:current_time) do |round: Undefined, refresh: false|
              round_to = Undefined.coalesce(round, options.fetch(:round, Undefined))

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
