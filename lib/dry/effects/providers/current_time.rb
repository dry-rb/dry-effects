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

        option :fixed, default: -> { true }

        option :round, default: -> { Undefined }

        alias_method :fixed?, :fixed

        attr_reader :generator

        def call(stack, generator = Undefined, step: Undefined)
          @generator = Undefined.default(generator) do
            if !Undefined.equal?(step)
              IncrementingTimeGenerator.(step)
            elsif fixed?
              FixedTimeGenerator.()
            else
              RunningTimeGenerator.()
            end
          end
          super(stack)
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
