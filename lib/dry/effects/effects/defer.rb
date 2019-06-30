# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Defer < ::Module
        def initialize(identifier = Undefined)
          defer = Effect.new(type: :defer, name: :defer, identifier: identifier)
          later = Effect.new(type: :defer, name: :later, identifier: identifier)
          wait = Effect.new(type: :defer, name: :wait, identifier: identifier)

          module_eval do
            define_method(:defer) do |&block|
              ::Dry::Effects.yield(defer.payload(block))
            end

            define_method(:wait) do |promises|
              ::Dry::Effects.yield(wait.payload(promises))
            end

            define_method(:later) do |&block|
              ::Dry::Effects.yield(later.payload(block))
            end
          end
        end
      end
    end
  end
end
