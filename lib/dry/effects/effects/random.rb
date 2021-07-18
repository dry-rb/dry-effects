# frozen_string_literal: true

require "dry/effects/effect"

module Dry
  module Effects
    module Effects
      class Random < ::Module
        Rand = Effect.new(type: :random, name: :rand)

        def initialize
          super

          module_eval do
            define_method(:rand) { |n = nil| ::Dry::Effects.yield(Rand.payload(n)) }
          end
        end
      end
    end
  end
end
