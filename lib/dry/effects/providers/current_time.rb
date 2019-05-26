require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class CurrentTime < Provider
        def initialize(time = Undefined, identifier: Undefined)
          super(identifier: Undefined.default(identifier, :global))
          @time = time
        end

        def current_time
          Undefined.default(@time) { Time.now }
        end
      end
    end
  end
end
