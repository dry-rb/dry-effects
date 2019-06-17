# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Parallel < Provider[:parallel]
        def par
          proc { |&block| Thread.new { @run_with_stack.(&block) } }
        end

        def join(xs)
          xs.map(&:join).map(&:value)
        end

        def call(_, _)
          @run_with_stack = ::Dry::Effects.yield(Handler::FORK)
          super
        end
      end
    end
  end
end
