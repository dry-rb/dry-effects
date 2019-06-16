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

        option :repeat_signal, default: -> {
          :"effect_retry_repeat_#{identifier}"
        }

        option :attempts, default: -> { 0 }

        def call(_, _)
          loop do
            catch(repeat_signal) do
              return attempt { yield }
            end
          end
        end

        def repeat
          throw repeat_signal
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
