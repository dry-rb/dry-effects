# frozen_string_literal: true

require 'dry/effects/provider'
require 'dry/effects/instructions/raise'

module Dry
  module Effects
    module Providers
      class Resolve < Provider[:resolve]
        def self.handle_method(*, as: Undefined, **)
          Undefined.default(as, :provide)
        end

        include Dry::Equalizer(:static, :parent, :dynamic, :overridable)

        Locate = Effect.new(type: :resolve, name: :locate)

        param :static, default: -> { EMPTY_HASH }

        attr_reader :parent

        attr_reader :dynamic

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

        def locate
          self
        end

        def call(stack, dynamic = EMPTY_HASH, options = EMPTY_HASH)
          @dynamic = dynamic

          if options.fetch(:overridable, false)
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
          static.key?(key) || dynamic.key?(key) || parent&.key?(key)
        end
      end
    end
  end
end
