# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Lock < ::Module
        def initialize(identifier = Undefined)
          lock = Effect.new(type: :lock, name: :lock, identifier: identifier)
          unlock = Effect.new(type: :lock, name: :unlock, identifier: identifier)
          locked = Effect.new(type: :lock, name: :locked?, identifier: identifier)

          module_eval do
            define_method(:lock) do |key, &block|
              if block
                begin
                  handle = ::Dry::Effects.yield(lock.payload(key))
                  block.(!handle.nil?)
                ensure
                  ::Dry::Effects.yield(unlock.payload(handle)) if handle
                end
              else
                ::Dry::Effects.yield(lock.payload(key))
              end
            end

            define_method(:unlock) do |key|
              ::Dry::Effects.yield(unlock.payload(key))
            end

            define_method(:locked?) do |key|
              ::Dry::Effects.yield(locked.payload(key))
            end
          end
        end
      end
    end
  end
end
