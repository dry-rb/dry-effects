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
            if Undefined.equal?(default)
              define_method(as) do |&block|
                if block
                  Undefined.default(::Dry::Effects.yield(read) { Undefined }, &block)
                else
                  value = ::Dry::Effects.yield(read) { raise Errors::MissingStateError, read }

                  Undefined.default(value) { raise Errors::UndefinedStateError, read }
                end
              end
            else
              define_method(as) do |&block|
                if block
                  Undefined.default(::Dry::Effects.yield(read) { Undefined }, &block)
                else
                  Undefined.default(::Dry::Effects.yield(read) { Undefined }, default)
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
