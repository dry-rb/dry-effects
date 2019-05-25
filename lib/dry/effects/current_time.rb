require 'dry/effects/effect'

module Dry
  module Effects
    class CurrentTime < ::Module
      def initialize
        current_time = Effect.new(:current_time, :current_time)
        module_eval do
          define_method(:current_time) { Effects.yield(current_time) }
        end
      end
    end
  end
end
