# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Async < Provider[:async]
        option :tasks, default: -> { ::Hash.new }

        include Dry::Equalizer(:tasks)

        attr_reader :stack

        def async(block)
          @tasks[block] = block
        end

        def await(task)
          Frame.spawn_fiber(stack, &@tasks.delete(task))
        end

        # Yield the block with the handler installed
        #
        # @api private
        def call(stack)
          @stack = stack
          super
          nil
        end
      end
    end
  end
end
