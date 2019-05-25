require 'dry/effects/effect'

module Dry
  module Effects
    class CurrentTime < ::Module
      def initialize(identifier = :global)
        current_time = Effect.new(:current_time, :current_time, identifier)
        module_eval do
          define_method(:current_time) { Effects.yield(current_time) }
        end
      end
    end
  end
end
