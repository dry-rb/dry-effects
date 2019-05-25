require 'dry/effects/consumer'

module Dry
  module Effects
    module Consumers
      class CurrentTime < Consumer
        def initialize(time = Undefined, identifier: :default)
          super(identifier: identifier)
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
