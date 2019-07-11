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

        def initialize(scope, default: Undefined, writer: true, as: scope)
          read = StateEffect.new(type: :state, name: :read, scope: scope)
          write = StateEffect.new(type: :state, name: :write, scope: scope)

          module_eval do
            define_method(as) do |&block|
              if block
                ::Dry::Effects.yield(read, &block)
              else
                ::Dry::Effects.yield(read) do |eff, _|
                  if Undefined.equal?(default)
                    raise Errors::MissingState, eff
                  else
                    default
                  end
                end
              end
            end

            if writer
              define_method(:"#{as}=") do |value|
                ::Dry::Effects.yield(write.(value))
              end
            end
          end
        end
      end
    end
  end
end
