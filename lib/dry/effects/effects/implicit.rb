# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Implicit < ::Module
        def initialize(method)
          lookup = Effect.new(type: :implicit, identifier: method)

          module_eval do
            define_method(method) do |arg|
              ::Dry::Effects.yield(lookup.payload(arg)).(arg)
            end
          end
        end
      end
    end
  end
end
