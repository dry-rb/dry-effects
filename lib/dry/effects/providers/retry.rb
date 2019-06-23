# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Retry < Provider[:retry]
        def self.mixin(identifier, **kwargs)
          super(identifier: identifier, **kwargs)
        end

        param :limit

        option :identifier

        option :repeat_signal, default: lambda {
          :"effect_retry_repeat_#{identifier}"
        }

        option :attempts, default: -> { 0 }

        def call(_, _)
          loop do
            return attempt { yield }
          rescue Halt[repeat_signal]
          end
        end

        def repeat
          Instructions.Raise(Halt[repeat_signal].new)
        end

        def attempt
          if attempts_exhausted?
            nil
          else
            @attempts += 1
            yield
          end
        end

        def attempts_exhausted?
          @attempts.equal?(limit)
        end
      end
    end
  end
end
