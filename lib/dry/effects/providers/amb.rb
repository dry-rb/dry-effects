require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Amb < Provider[:amb]
        include Dry::Equalizer(:identifier)

        def self.mixin(identifier, **kwargs)
          super(identifier: identifier, **kwargs)
        end

        option :identifier

        def initialize(*)
          super
          @value = false
        end

        def get
          @value
        end

        def call(_, _)
          first = yield
          @value = true
          [first, yield]
        end

        def provide?(effect)
          super && identifier.equal?(effect.identifier)
        end
      end
    end
  end
end
