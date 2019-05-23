module Dry
  module Effects
    module Consumers
      class Random
        public :rand

        def initialize(_seed = Undefined)
        end

        def output(result)
          result
        end
      end
    end
  end
end
