require 'dry/effects/consumer'

module Dry
  module Effects
    module Consumers
      class Random < Consumer
        public :rand

        def initialize(_seed = Undefined, identifier: :default)
          super(identifier: identifier)
        end

        def output(result)
          result
        end
      end
    end
  end
end
