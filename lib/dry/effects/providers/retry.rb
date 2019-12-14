# frozen_string_literal: true

require 'dry/effects/provider'
require 'dry/effects/halt'

module Dry
  module Effects
    module Providers
      class Retry < Provider[:retry]
        include Dry::Equalizer(:scope, :limit, :attempts, inspect: false)

        param :scope

        attr_reader :attempts

        attr_reader :limit

        # Yield the block with the handler installed
        #
        # @api private
        def call(limit)
          @limit = limit
          @attempts = 0

          loop do
            begin
              return attempt { yield }
            rescue halt
            end
          end
        end

        def retry
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

        # @return [String]
        # @api public
        def represent
          "retry[#{scope} #{attempts}/#{limit}]"
        end
      end
    end
  end
end
