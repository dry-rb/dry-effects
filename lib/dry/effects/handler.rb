# frozen_string_literal: true

module Dry
  module Effects
    class Handler
      attr_reader :provider

      attr_reader :frame

      def initialize(type, *args)
        @provider = ::Dry::Effects.providers[type].new(*args)
        @frame = Frame.new(provider)
      end

      if RUBY_VERSION >= '2.7'
        class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
          def call(...)
            frame.(...)
          end
        RUBY
      else
        def call(*args, &block)
          frame.(*args, &block)
        end
      end

      def to_s
        "#<Dry::Effects::Handler #{provider.represent}>"
      end
      alias_method :inspect, :to_s
    end
  end
end
