# frozen_string_literal: true

require 'concurrent/promise'
require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Defer < Provider[:defer]
        option :executor, default: -> { :io }

        def defer(block)
          ::Concurrent::Promise.execute(executor: executor) do
            @run_with_stack.(&block)
          end
        end

        def wait(promises)
          if promises.is_a?(::Array)
            ::Concurrent::Promise.zip(*promises).value!
          else
            promises.value!
          end
        end

        def call(_, _)
          @run_with_stack = ::Dry::Effects.yield(Handler::FORK) { -> &cont { cont.call } }
          super
        end
      end
    end
  end
end
