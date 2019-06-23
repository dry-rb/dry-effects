# frozen_string_literal: true

require 'concurrent/promise'
require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Parallel < Provider[:parallel]
        option :executor, default: -> { :io }

        def par
          proc do |&block|
            ::Concurrent::Promise.execute(executor: executor) do
              @run_with_stack.(&block)
            end
          end
        end

        def join(xs)
          xs.map(&:value!)
        end

        def call(_, _)
          @run_with_stack = ::Dry::Effects.yield(Handler::FORK) { -> &cont { cont.call } }
          super
        end
      end
    end
  end
end
