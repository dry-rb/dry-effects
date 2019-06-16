require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Random < ::Module
        def initialize
          read = Effect.new(type: :random, name: :rand)

          module_eval do
            define_method(:rand) { |n| ::Dry::Effects.yield(read.payload(n)) }
          end
        end
      end
    end
  end
end
