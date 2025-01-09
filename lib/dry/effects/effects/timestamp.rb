# frozen_string_literal: true

module Dry
  module Effects
    module Effects
      class Timestamp < ::Module
        Timestamp = Effect.new(type: :timestamp)

        def initialize(options = EMPTY_HASH)
          super()

          module_eval do
            define_method(:timestamp) do |round: Undefined|
              round_to = Undefined.coalesce(round, options.fetch(:round, Undefined))

              if Undefined.equal?(round_to)
                ::Dry::Effects.yield(Timestamp)
              else
                ::Dry::Effects.yield(Timestamp.keywords(round_to:))
              end
            end
          end
        end
      end
    end
  end
end
