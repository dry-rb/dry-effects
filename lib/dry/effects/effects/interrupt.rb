# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Interrupt < ::Module
        class InterruptEffect < Effect
          option :scope
        end

        def initialize(scope = :default)
          interrupt = InterruptEffect.new(type: :interrupt, scope: scope)

          module_eval do
            define_method(scope) do |payload = Undefined|
              if Undefined.equal?(payload)
                ::Dry::Effects.yield(interrupt)
              else
                ::Dry::Effects.yield(interrupt.(payload))
              end
            end
          end
        end
      end
    end
  end
end
