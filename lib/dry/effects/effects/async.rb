# frozen_string_literal: true

module Dry
  module Effects
    module Effects
      class Async < ::Module
        def initialize(identifier = Undefined)
          async = Effect.new(type: :async, name: :async, identifier: identifier)
          await = Effect.new(type: :async, name: :await, identifier: identifier)

          module_eval do
            define_method(:async) { |&block| ::Dry::Effects.yield(async.payload(block)) }
            define_method(:await) { |task| ::Dry::Effects.yield(await.payload(task)) }
          end
        end
      end
    end
  end
end
