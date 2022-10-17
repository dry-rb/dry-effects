# frozen_string_literal: true

module Dry
  module Effects
    module Effects
      class Parallel < ::Module
        Par = Effect.new(type: :parallel, name: :par)
        Join = Effect.new(type: :parallel, name: :join)

        def initialize
          super

          define_method(:par) { |&block| ::Dry::Effects.yield(Par).(&block) }
          define_method(:join) { ::Dry::Effects.yield(Join.payload(_1)) }
        end
      end
    end
  end
end
