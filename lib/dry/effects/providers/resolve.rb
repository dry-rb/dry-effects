# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Resolve < Provider[:resolve]
        class << self
          def handle_method(*, as: Undefined, **)
            Undefined.default(as, :provide)
          end
        end

        include Dry::Equalizer(:container)

        param :container

        option :identifier, default: -> { Undefined }

        option :overridable, default: -> { false }

        attr_reader :parent

        def call(stack, index)
          if overridable
            locate = Effect.new(
              type: :resolve,
              name: :locate,
              identifier: :default
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

        def locate
          self
        end

        def provide?(effect)
          if type.equal?(effect.type)
            if effect.name.equal?(:resolve)
              key?(effect.identifier)
            else
              effect.name.equal?(:locate)
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
