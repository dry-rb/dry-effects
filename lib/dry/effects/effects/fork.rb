# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Fork < ::Module
        Fork = Effect.new(type: :fork)

        def initialize
          define_method(:fork) { |&block| ::Dry::Effects.yield(Fork).(&block) }
        end
      end
    end
  end
end
