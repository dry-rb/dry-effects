# frozen_string_literal: true

require "dry/effects/effect"

module Dry
  module Effects
    module Effects
      class Timeout < ::Module
        class TimeoutEffect < Effect
          include ::Dry::Equalizer(:type, :name, :scope)

          option :scope
        end

        def initialize(scope)
          timeout = TimeoutEffect.new(type: :timeout, name: :timeout, scope: scope)

          module_eval do
            define_method(:timeout) do
              ::Dry::Effects.yield(timeout)
            end

            def timed_out?
              timeout.zero?
            end
          end
        end
      end
    end
  end
end
