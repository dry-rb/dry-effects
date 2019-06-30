# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Retry < ::Module
        class RetryEffect < Effect
          option :scope
        end

        def initialize
          module_eval do
            define_method(:repeat) do |scope|
              effect = RetryEffect.new(type: :retry, name: :repeat, scope: scope)
              ::Dry::Effects.yield(effect)
            end
          end
        end
      end
    end
  end
end
