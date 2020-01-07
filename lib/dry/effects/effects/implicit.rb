# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Implicit < ::Module
        class ImplicitEffect < Effect
          option :dependency
        end

        def initialize(dependency)
          lookup = ImplicitEffect.new(type: :implicit, dependency: dependency)

          module_eval do
            define_method(dependency) do |*args|
              ::Dry::Effects.yield(lookup.payload(args[0])).(*args)
            end
          end
        end
      end
    end
  end
end
