module Dry
  module Effects
    class Handler
      attr_reader :provider

      attr_reader :frame

      def initialize(type, *args)
        @provider = ::Dry::Effects.providers[type].new(*args)
        @frame = Frame.new(provider)
      end

      def call(*args, &block)
        frame.(args, &block)
      end

      def to_s
        "#<Dry::Effects::Handler #{provider.represent}>"
      end
      alias_method :inspect, :to_s
    end
  end
end
