# frozen_string_literal: true

module Dry
  module Effects
    module Effects
      class Cmp < ::Module
        class CmpEffect < Effect
          option :id
        end

        def initialize(id)
          super()

          get = CmpEffect.new(type: :cmp, name: :get, id: id)

          module_eval do
            define_method(:"#{id}?") { ::Dry::Effects.yield(get) }
          end
        end
      end
    end
  end
end
