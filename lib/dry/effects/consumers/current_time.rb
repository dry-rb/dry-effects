module Dry
  module Effects
    module Consumers
      class CurrentTime
        def initialize(time = Undefined)
          @time = time
        end

        def current_time
          Undefined.default(@time) { Time.now }
        end

        def output(result)
          result
        end
      end
    end
  end
end
