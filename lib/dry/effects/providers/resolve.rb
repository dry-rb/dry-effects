# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Resolve < Provider[:resolve]
        def self.handle_method(*, as: Undefined, **)
          Undefined.default(as, :provide)
        end

        include Dry::Equalizer(:container)

        param :container

        option :identifier, default: -> { Undefined }

        option :overridable, default: -> { false }

        attr_reader :parent

        attr_reader :index

        def call(stack, index)
          @index = index

          if overridable
            locate = Effect.new(
              type: :resolve,
              name: :locate,
              payload: [index]
            )
            @parent = ::Dry::Effects.yield(locate) { nil }

            super
          else
            super
          end
        end

        def resolve(key)
          if overridable && parent && parent.container.key?(key)
            parent.resolve(key)
          else
            container.fetch(key)
          end
        end

        def locate(_)
          self
        end

        def provide?(effect)
          if type.equal?(effect.type)
            if effect.name.equal?(:resolve)
              key?(effect.identifier)
            else
              effect.name.equal?(:locate) && index < effect.payload[0]
            end
          else
            false
          end
        end

        def key?(key)
          container.key?(key)
        end
      end
    end
  end
end
