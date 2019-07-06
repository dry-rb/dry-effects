# frozen_string_literal: true

require 'concurrent/promise'
require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Defer < Provider[:defer]
        option :executor, default: -> { :io }

        include Dry::Equalizer(:executor)

        attr_reader :later_calls

        attr_reader :stack

        def defer(block)
          stack = self.stack.dup
          ::Concurrent::Promise.execute(executor: executor) do
            Handler.spawn_fiber(stack, &block)
          end
        end

        def later(block)
          stack = self.stack.dup
          @later_calls << ::Concurrent::Promise.new(executor: executor) do
            Handler.spawn_fiber(stack, &block)
          end
          nil
        end

        def wait(promises)
          if promises.is_a?(::Array)
            ::Concurrent::Promise.zip(*promises).value!
          else
            promises.value!
          end
        end

        def call(stack, _ = Undefined)
          @stack = stack
          @later_calls = []
          super
        ensure
          later_calls.each(&:execute)
        end
      end
    end
  end
end
