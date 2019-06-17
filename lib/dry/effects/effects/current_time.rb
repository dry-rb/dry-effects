# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class CurrentTime < ::Module
        def initialize(_identifier = Undefined)
          current_time = Effect.new(type: :current_time)
          module_eval do
            define_method(:current_time) { ::Dry::Effects.yield(current_time) }
          end
        end
      end
    end
  end
end
