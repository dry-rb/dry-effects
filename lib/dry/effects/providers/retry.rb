# frozen_string_literal: true

require 'dry/effects/provider'
require 'dry/effects/halt'

module Dry
  module Effects
    module Providers
      class Retry < Provider[:retry]
        include Dry::Equalizer(:scope, :limit, :attempts)

        param :scope

        attr_reader :attempts

        attr_reader :limit

        def call(_, limit)
          @limit = limit
          @attempts = 0

          loop do
            return attempt { yield }
          rescue halt
          end
        end

        def repeat
          Instructions.Raise(halt.new)
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
          attempts.equal?(limit)
        end

        def halt
          Halt[scope]
        end

        def provide?(effect)
          super && scope.equal?(effect.scope)
        end
      end
    end
  end
end
