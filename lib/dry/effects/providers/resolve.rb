# frozen_string_literal: true

module Dry
  module Effects
    module Providers
      class Resolve < Provider[:resolve]
        def self.handle_method(*, as: Undefined, **)
          Undefined.default(as, :provide)
        end

        include Dry::Equalizer(:static, :parent, :dynamic, inspect: false)

        Locate = Effect.new(type: :resolve, name: :locate)

        param :static, default: -> { EMPTY_HASH }

        attr_reader :parent

        attr_reader :dynamic

        def initialize(*)
          super
          @dynamic = EMPTY_HASH
        end

        def resolve(key)
          if parent&.key?(key)
            parent.resolve(key)
          elsif dynamic.key?(key)
            dynamic[key]
          elsif static.key?(key)
            static[key]
          else
            Instructions.Raise(Errors::ResolutionError.new(key))
          end
        end

        # Locate handler in the stack
        #
        # @return [Provider]
        # @api private
        def locate
          self
        end

        # Yield the block with the handler installed
        #
        # @api private
        def call(dynamic = EMPTY_HASH, options = EMPTY_HASH)
          @dynamic = dynamic

          if options.fetch(:overridable, false)
            @parent = ::Dry::Effects.yield(Locate) { nil }
          else
            @parent = nil
          end

          yield
        ensure
          @dynamic = EMPTY_HASH
        end

        # @param [Effect] effect
        # @return [Boolean]
        # @api public
        def provide?(effect)
          if super
            !effect.name.equal?(:resolve) || key?(effect.payload[0])
          else
            false
          end
        end

        # @param [Symbol,String] key Dependency key
        # @return [Boolean]
        # @api public
        def key?(key)
          static.key?(key) || dynamic.key?(key) || parent&.key?(key)
        end

        # @return [String]
        # @api public
        def represent
          containers = [represent_container(static), represent_container(dynamic)].compact.join("+")
          "resolve[#{containers.empty? ? "empty" : containers}]"
        end

        # @return [String]
        # @api private
        def represent_container(container)
          case container
          when ::Hash
            container.empty? ? nil : "hash"
          when ::Class
            container.name || container.to_s
          else
            container.to_s
          end
        end
      end
    end
  end
end
