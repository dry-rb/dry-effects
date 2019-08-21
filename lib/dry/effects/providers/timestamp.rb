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

        def call(stack, generator = Undefined, step: Undefined, overridable: false)
          @generator = build_generator(generator, step, overridable)
          super(stack)
        end

        def build_generator(generator, step, overridable)
          if overridable
            parent = ::Dry::Effects.yield(Locate) { nil }
          else
            parent = nil
          end

          if !parent.nil?
            -> options { parent.timestamp(options) }
          elsif !Undefined.equal?(generator)
            generator
          elsif !Undefined.equal?(step)
            IncrementingTimeGenerator.(step)
          else
            RunningTimeGenerator.()
          end
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

        def locate
          self
        end
      end
    end
  end
end
