# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Implicit < ::Module
        def initialize(method)
          lookup = Effect.new(type: :implicit, identifier: method)

          module_eval do
            define_method(method) do |*args|
              ::Dry::Effects.yield(lookup.payload(args[0])).(*args)
            end
          end
        end
      end
    end
  end
end
