require 'dry/effects/handler'

module Dry
  module Effects
    class Fork < ::Module
      def initialize(_ = Undefined)
        define_method(:fork) { |&block| Effects.yield(Handler::FORK).(&block)}
      end
    end
  end
end
