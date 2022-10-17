# frozen_string_literal: true

module Dry
  module Effects
    module Providers
      class Random < Provider[:random]
        DEFAULT_RANDOM = ::Random
        DEFAULT = -> _ { DEFAULT_RANDOM.rand }

        DEFAULT_RANGE = (0.0...1.0).freeze

        def rand(range_or_limit = nil)
          range_or_limit ||= DEFAULT_RANGE

          if range_or_limit.is_a?(::Range)
            low = range_or_limit.begin
            high = range_or_limit.end
            exclude_end = range_or_limit.exclude_end?
          elsif range_or_limit >= 1
            low = 0
            high = range_or_limit.floor
            exclude_end = true
          else
            low = 0.0
            high = range_or_limit.to_f
            exclude_end = true
          end

          if low.is_a?(::Integer)
            next_integer(low, high, exclude_end)
          else
            next_float(low, high)
          end
        end

        def call(options = Undefined)
          @prev = nil
          @generator = build_generator(options)
          yield
        end

        def next_integer(low, high, exclude_end)
          @prev = @generator.(@prev) % 1

          value = low + (@prev * (high - low)).round

          if value.eql?(high) && exclude_end
            low
          else
            value
          end
        end

        def next_float(low, high)
          @prev = @generator.(@prev) % 1

          low + (@prev * (high - low))
        end

        def build_generator(options)
          case options
          when Undefined
            DEFAULT
          when ::Hash
            if options.key?(:seed)
              random = ::Random.new(options[:seed])
            else
              random = DEFAULT_RANDOM
            end

            -> _ { random.rand }
          else
            generator = options

            lambda do |prev|
              prev.nil? ? generator.() : generator.(prev)
            end
          end
        end
      end
    end
  end
end
