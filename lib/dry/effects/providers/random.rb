require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Random < Provider
        public :rand

        def initialize(_seed = Undefined, identifier: Undefined)
          super(identifier: Undefined.default(identifier, :kernel))
        end

        def output(result)
          result
        end
      end
    end
  end
end
