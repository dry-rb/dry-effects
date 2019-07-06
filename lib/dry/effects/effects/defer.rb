# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Defer < ::Module
        Defer = Effect.new(type: :defer, name: :defer)
        Later = Effect.new(type: :defer, name: :later)
        Wait = Effect.new(type: :defer, name: :wait)

        def initialize
          module_eval do
            define_method(:defer) do |&block|
              ::Dry::Effects.yield(Defer.(block))
            end

            define_method(:wait) do |promises|
              ::Dry::Effects.yield(Wait.(promises))
            end

            define_method(:later) do |&block|
              ::Dry::Effects.yield(Later.(block))
            end
          end
        end
      end
    end
  end
end
