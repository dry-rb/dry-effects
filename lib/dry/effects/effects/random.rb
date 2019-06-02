require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Random < ::Module
        def initialize(identifier = Undefined)
          read = Effect.new(
            type: :random,
            name: :rand,
            identifier: Undefined.default(identifier, :kernel)
          )

          module_eval do
            define_method(:rand) { |n| ::Dry::Effects.yield(read.payload(n)) }
          end
        end
      end
    end
  end
end
