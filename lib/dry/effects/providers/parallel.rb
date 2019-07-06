# frozen_string_literal: true

require 'concurrent/promise'
require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Parallel < Provider[:parallel]
        option :executor, default: -> { :io }

        attr_reader :stack

        def par
          stack = self.stack.dup
          proc do |&block|
            ::Concurrent::Promise.execute(executor: executor) do
              Handler.spawn_fiber(stack, &block)
            end
          end
        end

        def join(xs)
          xs.map(&:value!)
        end

        def call(stack)
          @stack = stack
          super
        end
      end
    end
  end
end
