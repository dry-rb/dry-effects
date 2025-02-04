# frozen_string_literal: true

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
        def call(limit, &block)
          @limit = limit
          @attempts = 0

          loop do
            return attempt(&block)
          rescue halt # rubocop:disable Lint/SuppressedException
          end
        end

        def retry = Instructions.Raise(halt.new)

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

        def halt = Halt[scope]

        def provide?(effect) = super && scope.equal?(effect.scope)

        # @return [String]
        # @api public
        def represent = "retry[#{scope} #{attempts}/#{limit}]"
      end
    end
  end
end
