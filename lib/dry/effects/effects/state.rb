# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class State < ::Module
        class StateEffect < Effect
          option :scope
        end

        def initialize(scope)
          read = StateEffect.new(type: :state, name: :read, scope: scope)
          write = StateEffect.new(type: :state, name: :write, scope: scope)

          module_eval do
            define_method(scope) { ::Dry::Effects.yield(read) }

            define_method(:"#{scope}=") do |value|
              ::Dry::Effects.yield(write.(value))
            end
          end
        end
      end
    end
  end
end
