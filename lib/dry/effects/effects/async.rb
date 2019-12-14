# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Async < ::Module
        Async = Effect.new(type: :async, name: :async)

        Await = Effect.new(type: :async, name: :await)

        def initialize
          module_eval do
            define_method(:async) { |&block| ::Dry::Effects.yield(Async.(block)) }
            define_method(:await) { |task| ::Dry::Effects.yield(Await.(task)) }
          end
        end
      end
    end
  end
end
