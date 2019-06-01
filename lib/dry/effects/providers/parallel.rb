require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Parallel < Provider[:parallel]
        def initialize(identifier: Undefined)
          super(identifier: Undefined.default(identifier, :root))
          @run_with_stack = Undefined
        end

        def par
          proc { |&block| Thread.new { @run_with_stack.(&block) } }
        end

        def join(xs)
          xs.map(&:join).map(&:value)
        end

        def call
          @run_with_stack = Effects.yield(Handler::FORK)
          super
        end
      end
    end
  end
end
