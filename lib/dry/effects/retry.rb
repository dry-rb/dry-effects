require 'dry/effects/effect'

module Dry
  module Effects
    class Retry < ::Module
      def initialize(identifier)
        module_eval do
          define_method(:repeat) { |id| Effects.yield(Effect.new(:retry, :repeat, id)) }
        end
      end
    end
  end
end
