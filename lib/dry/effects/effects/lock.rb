# frozen_string_literal: true

module Dry
  module Effects
    module Effects
      class Lock < ::Module
        Lock = Effect.new(type: :lock, name: :lock)
        Meta = Effect.new(type: :lock, name: :meta)
        Unlock = Effect.new(type: :lock, name: :unlock)
        Locked = Effect.new(type: :lock, name: :locked?)

        def initialize
          super

          module_eval do
            define_method(:lock) do |key, meta: Undefined, &block|
              if block
                begin
                  handle = ::Dry::Effects.yield(Lock.payload(key, meta))
                  block.(!handle.nil?)
                ensure
                  ::Dry::Effects.yield(Unlock.payload(handle)) if handle
                end
              else
                ::Dry::Effects.yield(Lock.payload(key, meta))
              end
            end

            define_method(:unlock) do |key|
              ::Dry::Effects.yield(Unlock.(key))
            end

            define_method(:locked?) do |key|
              ::Dry::Effects.yield(Locked.payload(key))
            end

            define_method(:lock_meta) do |key|
              ::Dry::Effects.yield(Meta.payload(key))
            end
          end
        end
      end
    end
  end
end
