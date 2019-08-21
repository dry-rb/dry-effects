# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class CurrentTime < Provider[:current_time]
        include Dry::Equalizer(:fixed, :round)

        FixedTimeGenerator = lambda do
          time = ::Time.now
          lambda do |refresh: false, **|
            time = ::Time.now if refresh
            time
          end
        end

        RunningTime = -> ** { ::Time.now }
        RunningTimeGenerator = -> { RunningTime }

        IncrementingTimeGenerator = lambda do |step|
          start = ::Time.now
          current = nil

          lambda do |**|
            if current.nil?
              current = start
            else
              current += step
            end
          end
        end

        Locate = Effect.new(type: :current_time, name: :locate)

        option :fixed, default: -> { true }

        option :round, default: -> { Undefined }

        alias_method :fixed?, :fixed

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
            -> options { parent.current_time(options) }
          elsif !Undefined.equal?(generator)
            generator
          elsif !Undefined.equal?(step)
            IncrementingTimeGenerator.(step)
          elsif fixed?
            FixedTimeGenerator.()
          else
            RunningTimeGenerator.()
          end
        end

        def current_time(round_to: Undefined, **options)
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

        def represent
          if fixed?
            "current_time[fixed=#{generator.().iso8601(6)}]"
          else
            'current_time[fixed=false]'
          end
        end
      end
    end
  end
end
