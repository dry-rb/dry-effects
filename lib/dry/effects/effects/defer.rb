# frozen_string_literal: true

require "dry/effects/effect"

module Dry
  module Effects
    module Effects
      class Defer < ::Module
        Defer = Effect.new(type: :defer, name: :defer)
        Later = Effect.new(type: :defer, name: :later)
        Wait = Effect.new(type: :defer, name: :wait)

        def initialize
          super

          module_eval do
            define_method(:defer) do |executor: Undefined, &block|
              ::Dry::Effects.yield(Defer.(block, executor))
            end

            define_method(:wait) do |promises|
              ::Dry::Effects.yield(Wait.(promises))
            end

            define_method(:later) do |executor: Undefined, &block|
              ::Dry::Effects.yield(Later.(block, executor))
            end
          end
        end
      end
    end
  end
end
