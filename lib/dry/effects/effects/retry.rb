# frozen_string_literal: true

require "dry/effects/effect"
require "dry/effects/constructors"

module Dry
  module Effects
    module Effects
      class Retry < ::Module
        class Retry < Effect
          include ::Dry::Equalizer(:type, :name, :payload, :scope)

          option :scope
        end

        Constructors.register(:Retry) do |scope|
          Retry.new(type: :retry, scope: scope)
        end

        def initialize
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
