require 'dry/effects/effect'

module Dry
  module Effects
    class Random < ::Module
      def initialize
        read = Effect.new(:random, :rand)

        module_eval do
          define_method(:rand) { |n| Effects.yield(read.with(n)) }
        end
      end
    end
  end
end
