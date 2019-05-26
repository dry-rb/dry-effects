module Dry
  module Effects
    class Amb < ::Module
      def initialize(identifier)
        get = Effect.new(:amb, :get, identifier)
        module_eval do
          define_method(:"#{identifier}?") { Effects.yield(get) }
        end
      end
    end
  end
end
