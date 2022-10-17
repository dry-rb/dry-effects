# frozen_string_literal: true

module Dry
  module Effects
    module Effects
      class Async < ::Module
        Async = Effect.new(type: :async, name: :async)

        Await = Effect.new(type: :async, name: :await)

        def initialize
          super

          module_eval do
            define_method(:async) { |&block| ::Dry::Effects.yield(Async.(block)) }
            define_method(:await) { ::Dry::Effects.yield(Await.(_1)) }
          end
        end
      end
    end
  end
end
