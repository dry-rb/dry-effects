require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Interrupt < Provider
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
