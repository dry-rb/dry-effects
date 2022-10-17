# frozen_string_literal: true

module Dry
  module Effects
    module Effects
      class Fork < ::Module
        Fork = Effect.new(type: :fork)

        def initialize
          super

          module_eval(<<~RUBY, __FILE__, __LINE__ + 1)
            def fork
              yield(::Dry::Effects.yield(Fork))
            end
          RUBY
        end
      end
    end
  end
end
