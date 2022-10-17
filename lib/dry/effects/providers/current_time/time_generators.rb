# frozen_string_literal: true

module Dry
  module Effects
    module Providers
      class CurrentTime < Provider[:current_time]
        module TimeGenerators
          FixedTimeGenerator = lambda do
            time = ::Time.now
            lambda do |refresh: false, **|
              time = ::Time.now if refresh
              time
            end
          end

          RunningTime = -> ** { ::Time.now }
          RunningTimeGenerator = -> { RunningTime }

          IncrementingTimeGenerator = lambda do |initial, step|
            start = Undefined.default(initial) { ::Time.now }
            current = nil

            lambda do |**|
              if current.nil?
                current = start
              else
                current += step
              end
            end
          end
        end
      end
    end
  end
end
