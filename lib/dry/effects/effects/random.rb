# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Random < ::Module
        Read = Effect.new(type: :random, name: :rand)

        def initialize
          module_eval do
            define_method(:rand) { |n = nil| ::Dry::Effects.yield(Read.(n)) }
          end
        end
      end
    end
  end
end
