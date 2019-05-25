require 'dry/effects/consumer'

module Dry
  module Effects
    module Consumers
      class Interrupt < Consumer
        def interrupt(_ = Undefined)
          Handler::BREAK
        end

        def output(result)
          result.payload[0]
        end
      end
    end
  end
end
