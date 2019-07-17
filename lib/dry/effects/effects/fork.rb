# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Fork < ::Module
        Fork = Effect.new(type: :fork)

        def initialize
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
