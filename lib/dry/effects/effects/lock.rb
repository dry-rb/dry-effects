# frozen_string_literal: true

require 'dry/effects/effect'

module Dry
  module Effects
    module Effects
      class Lock < ::Module
        Lock = Effect.new(type: :lock, name: :lock)
        Unlock = Effect.new(type: :lock, name: :unlock)
        Locked = Effect.new(type: :lock, name: :locked?)

        def initialize
          module_eval do
            define_method(:lock) do |key, &block|
              if block
                begin
                  handle = ::Dry::Effects.yield(Lock.(key))
                  block.(!handle.nil?)
                ensure
                  ::Dry::Effects.yield(Unlock.(handle)) if handle
                end
              else
                ::Dry::Effects.yield(Lock.(key))
              end
            end

            define_method(:unlock) do |key|
              ::Dry::Effects.yield(Unlock.(key))
            end

            define_method(:locked?) do |key|
              ::Dry::Effects.yield(Locked.(key))
            end
          end
        end
      end
    end
  end
end
