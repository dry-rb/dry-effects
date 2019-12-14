# frozen_string_literal: true

require 'dry/effects/provider'
require 'dry/effects/providers/current_time'

module Dry
  module Effects
    module Providers
      class Timestamp < Provider[:timestamp]
        include Dry::Equalizer(:round)
        include CurrentTime::TimeGenetators

        Locate = Effect.new(type: :timestamp, name: :locate)

        option :round, default: -> { Undefined }

        attr_reader :generator

        # Yield the block with the handler installed
        #
        # @api private
        def call(stack, *args)
          gen, options = value_with_options_from_args(args)
          @generator = build_generator(gen, **options)
          super(stack)
        end

        def timestamp(round_to: Undefined, **options)
          time = generator.(**options)

          round = Undefined.coalesce(round_to, self.round)

          if Undefined.equal?(round)
            time
          else
            time.round(round)
          end
        end

        # Locate handler in the stack
        #
        # @return [Provider]
        # @api private
        def locate
          self
        end

        private

        # @return [Proc] time generator
        # @api private
        def build_generator(generator, step: Undefined, initial: Undefined, overridable: false)
          if overridable
            parent = ::Dry::Effects.yield(Locate) { nil }
          else
            parent = nil
          end

          if !parent.nil?
            -> **options { parent.timestamp(**options) }
          elsif !Undefined.equal?(generator)
            generator
          elsif !Undefined.equal?(step)
            IncrementingTimeGenerator.(initial, step)
          else
            RunningTimeGenerator.()
          end
        end
      end
    end
  end
end
