# frozen_string_literal: true

module Dry
  module Effects
    module Effects
      class Retry < ::Module
        class Retry < Effect
          include ::Dry::Equalizer(:type, :name, :payload, :scope)

          option :scope
        end

        def initialize
          super

          module_eval do
            define_method(:repeat) do |scope|
              effect = Retry.new(type: :retry, scope: scope)
              ::Dry::Effects.yield(effect)
            end
          end
        end
      end
    end
  end
end
