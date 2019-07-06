# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Resolve < Provider[:resolve]
        def self.handle_method(*, as: Undefined, **)
          Undefined.default(as, :provide)
        end

        include Dry::Equalizer(:container, :parent, :overridable)

        Locate = Effect.new(type: :resolve, name: :locate)

        param :container, default: -> { EMPTY_HASH }

        option :overridable, default: -> { false }

        attr_reader :parent

        def resolve(key)
          if parent && parent.container.key?(key)
            parent.resolve(key)
          else
            container.fetch(key)
          end
        end

        def locate
          self
        end

        def call(stack, container = EMPTY_HASH)
          unless container.empty?
            @container = @container.merge(container)
          end

          if overridable
            @parent = ::Dry::Effects.yield(Locate) { nil }
          else
            @parent = nil
          end

          super(stack)
        end

        def provide?(effect)
          if effect.type.equal?(:resolve)
            if effect.name.equal?(:resolve)
              key?(effect.payload[0])
            else
              true
            end
          else
            false
          end
        end

        def key?(key)
          container.key?(key) || parent && parent.key?(key)
        end
      end
    end
  end
end
