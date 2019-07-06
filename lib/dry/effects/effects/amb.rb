# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Amb < ::Module
        class AmbEffect < Effect
          option :id
        end

        def initialize(id)
          get = AmbEffect.new(type: :amb, name: :get, id: id)

          module_eval do
            define_method(:"#{id}?") { ::Dry::Effects.yield(get) }
          end
        end
      end
    end
  end
end
