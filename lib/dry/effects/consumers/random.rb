require 'dry/effects/consumer'

module Dry
  module Effects
    module Consumers
      class Random < Consumer
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
