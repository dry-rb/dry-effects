# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class State < ::Module
        def initialize(identifier)
          read = Effect.new(type: :state, name: :read, identifier: identifier)
          write = Effect.new(type: :state, name: :write, identifier: identifier)

          module_eval do
            define_method(identifier) { ::Dry::Effects.yield(read) }
            define_method(:"#{identifier}=") { |value| ::Dry::Effects.yield(write.payload(value)) }
          end
        end
      end
    end
  end
end
