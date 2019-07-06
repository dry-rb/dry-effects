# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class State < ::Module
        class StateEffect < Effect
          include ::Dry::Equalizer(:type, :name, :payload, :scope)

          option :scope
        end

        def initialize(scope, default: Undefined)
          read = StateEffect.new(type: :state, name: :read, scope: scope)
          write = StateEffect.new(type: :state, name: :write, scope: scope)

          module_eval do
            define_method(scope) do |&block|
              if block
                ::Dry::Effects.yield(read, &block)
              elsif Undefined.equal?(default)
                ::Dry::Effects.yield(read) do |eff, _|
                  raise Errors::MissingState, eff
                end
              else
                default
              end
            end

            define_method(:"#{scope}=") do |value|
              ::Dry::Effects.yield(write.(value))
            end
          end
        end
      end
    end
  end
end
