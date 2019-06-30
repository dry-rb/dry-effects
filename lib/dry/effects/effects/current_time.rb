# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class CurrentTime < ::Module
        CurrentTime = Effect.new(type: :current_time)

        def initialize
          module_eval do
            define_method(:current_time) { ::Dry::Effects.yield(CurrentTime) }
          end
        end
      end
    end
  end
end
