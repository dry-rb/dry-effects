require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Random < Provider[:random]
        public :rand

        def initialize(_seed = Undefined, identifier: Undefined)
          super(identifier: Undefined.default(identifier, :kernel))
        end
      end
    end
  end
end
