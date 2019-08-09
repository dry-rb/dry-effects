# frozen_string_literal: true

require 'dry/equalizer'
require 'dry/effects/provider'
require 'dry/effects/initializer'

module Dry
  module Effects
    module Providers
      class Lock < Provider[:lock]
        class Handle
          include ::Dry::Equalizer(:key)

          extend Initializer

          param :key
        end

        class Backend
          extend Initializer

          param :locks, default: -> { ::Hash.new }

          param :mutex, default: -> { ::Mutex.new }

          def lock(key)
            mutex.synchronize do
              if locked?(key)
                nil
              else
                locks[key] = Handle.new(key)
              end
            end
          end

          def locked?(key)
            locks.key?(key)
          end

          def unlock(handle)
            mutex.synchronize do
              if locked?(handle.key)
                locks.delete(handle.key)
                true
              else
                false
              end
            end
          end
        end

        Locate = Effect.new(type: :lock, name: :locate)

        option :backend, default: -> { Backend.new }

        def lock(key)
          locked = backend.lock(key)
          owned << locked if locked
          locked
        end

        def locked?(key)
          backend.locked?(key)
        end

        def unlock(handle)
          backend.unlock(handle)
        end

        def locate
          self
        end

        def call(stack, backend = Undefined)
          backend_replace = Undefined.default(backend) do
            parent = ::Dry::Effects.yield(Locate) { Undefined }
            Undefined.map(parent, &:backend)
          end

          with_backend(backend_replace) do
            super(stack)
          ensure
            owned.each { |handle| unlock(handle) }
          end
        end

        def with_backend(backend)
          if Undefined.equal?(backend)
            yield
          else
            begin
              before, @backend = @backend, backend
              yield
            ensure
              @backend = before
            end
          end
        end

        def owned
          @owned ||= []
        end

        def represent
          if owned.empty?
            super
          else
            "lock[owned=#{owned.size}]"
          end
        end
      end
    end
  end
end
