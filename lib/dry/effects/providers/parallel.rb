# frozen_string_literal: true

require "concurrent/promise"

module Dry
  module Effects
    module Providers
      class Parallel < Provider[:parallel]
        include ::Dry::Equalizer(:executor, inspect: false)

        option :executor, default: -> { :io }

        attr_reader :stack

        def par
          stack = self.stack.dup
          proc do |&block|
            ::Concurrent::Promise.execute(executor:) do
              Frame.spawn_fiber(stack, &block)
            end
          end
        end

        def join(xs) = xs.map(&:value!)

        # Yield the block with the handler installed
        #
        # @api private
        def call
          @stack = Frame.stack
          yield
        end
      end
    end
  end
end
