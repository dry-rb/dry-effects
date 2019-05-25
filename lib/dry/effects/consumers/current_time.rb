require 'dry/effects/consumer'

module Dry
  module Effects
    module Consumers
      class CurrentTime < Consumer
        def initialize(time = Undefined, identifier: Undefined)
          super(identifier: Undefined.default(identifier, :global))
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
