module Dry
  module Effects
    module Consumers
      class Random
        public :rand

        def output(result)
          result
        end
      end
    end
  end
end
