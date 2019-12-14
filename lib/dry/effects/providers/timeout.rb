# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Timeout < Provider[:timeout]
        def self.handle_method(scope, as: Undefined, **)
          Undefined.default(as) { :with_timeout }
        end

        param :scope

        def timeout
          left = @time_out_at - read_clock

          if left <= 0
            0.0
          else
            left
          end
        end

        # Yield the block with the handler installed
        #
        # @api private
        def call(timeout)
          @time_out_at = read_clock + timeout

          yield
        end

        # @param [Effect] effect
        # @return [Boolean]
        # @api public
        def provide?(effect)
          effect.type.equal?(:timeout) && scope.equal?(effect.scope)
        end

        def read_clock
          ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)
        end
      end
    end
  end
end
