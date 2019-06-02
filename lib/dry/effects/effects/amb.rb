module Dry
  module Effects
    module Effects
      class Amb < ::Module
        def initialize(identifier)
          get = Effect.new(type: :amb, name: :get, identifier: identifier)
          module_eval do
            define_method(:"#{identifier}?") { ::Dry::Effects.yield(get) }
          end
        end
      end
    end
  end
end
