# frozen_string_literal: true

require 'concurrent/promise'
require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Defer < Provider[:defer]
        option :executor, default: -> { :io }

        def defer(callable)
          ::Concurrent::Promise.execute(executor: executor, &callable)
        end

        def wait(promises)
          if promises.is_a?(::Array)
            ::Concurrent::Promise.zip(*promises).value!
          else
            promises.value!
          end
        end
      end
    end
  end
end
