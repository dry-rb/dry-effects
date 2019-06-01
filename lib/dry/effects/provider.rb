require 'dry/effects/initializer'
require 'dry/core/class_attributes'

module Dry
  module Effects
    class Provider
      extend Initializer
      extend Core::ClassAttributes
      include Dry::Equalizer(:identifier)

      defines :type

      @mutex = ::Mutex.new
      @effects = ::Hash.new do |es, type|
        @mutex.synchronize do
          es.fetch(type) do
            es[type] = Class.new(Provider).tap do |provider|
              provider.type type
            end
          end
        end
      end

      def self.[](type)
        @effects[type]
      end

      option :identifier, type: -> id {
        Undefined.default(id) { raise ArgumentError, "No identifier given" }
      }

      def call
        yield
      end

      def represent
        "#{type}##{identifier}"
      end

      def type
        self.class.type
      end
    end
  end
end
