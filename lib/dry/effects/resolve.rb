require 'dry/effects/effect'

module Dry
  module Effects
    class Resolve < ::Module
      def initialize(identifier)
        resolve = Effect.new(type: :resolve, identifier: identifier)

        module_eval do
          define_method(identifier) { ::Dry::Effects.yield(resolve) }
        end
      end
    end
  end
end
