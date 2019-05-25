require 'dry/effects/effect'

module Dry
  module Effects
    class CurrentTime < ::Module
      CURRENT_TIME = Effect.new(:current_time, :current_time)

      def initialize
        module_eval do
          def current_time
            Fiber.yield(CURRENT_TIME)
          end
        end
      end
    end
  end
end
