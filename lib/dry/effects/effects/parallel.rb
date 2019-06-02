module Dry
  module Effects
    module Effects
      class Parallel < ::Module
        def initialize(identifier = Undefined)
          id = Undefined.default(identifier, :root)
          par = Effect.new(type: :parallel, name: :par, identifier: id)
          join = Effect.new(type: :parallel, name: :join, identifier: id)

          define_method(:par) { |&block| ::Dry::Effects.yield(par).(&block) }
          define_method(:join) { |xs| ::Dry::Effects.yield(join.payload(xs)) }
        end
      end
    end
  end
end
