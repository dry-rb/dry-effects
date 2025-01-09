# frozen_string_literal: true

module Dry
  module Effects
    module Effects
      class CurrentTime < ::Module
        CurrentTime = Effect.new(type: :current_time)

        def initialize(**options)
          super()

          module_eval do
            define_method(:current_time) do |opts = EMPTY_HASH|
              round = opts.fetch(:round, Undefined)
              refresh = opts.fetch(:refresh, false)
              round_to = Undefined.coalesce(round, options.fetch(:round, Undefined))

              if Undefined.equal?(round_to) && refresh.equal?(false)
                effect = CurrentTime
              else
                effect = CurrentTime.(round_to:, refresh:)
              end

              ::Dry::Effects.yield(effect)
            end
          end
        end
      end
    end
  end
end
