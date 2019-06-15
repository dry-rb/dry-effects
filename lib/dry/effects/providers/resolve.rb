require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Resolve < Provider[:resolve]
        def self.handle_method(*, as: Undefined, **)
          Undefined.default(as, :provide)
        end

        include Dry::Equalizer(:container)

        attr_reader :container

        option :identifier, default: -> { Undefined }

        def initialize(container, identifier:)
          super()
          @container = container
        end

        def resolve(key)
          container.fetch(key)
        end

        def provide?(effect)
          type.equal?(effect.type) && container.key?(effect.identifier)
        end
      end
    end
  end
end
