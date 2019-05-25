require 'dry/effects/effect'

module Dry
  module Effects
    class Random < ::Module
      def initialize(identifier = :kernel)
        read = Effect.new(:random, :rand, identifier)

        module_eval do
          define_method(:rand) { |n| Effects.yield(read.with(n)) }
        end
      end
    end
  end
end
