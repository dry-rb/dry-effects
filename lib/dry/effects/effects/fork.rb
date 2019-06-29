# frozen_string_literal: true

require 'dry/effects/handler'

module Dry
  module Effects
    module Effects
      class Fork < ::Module
        def initialize(identifier = Undefined)
          fork = Effect.new(type: :fork, identifier: identifier)

          define_method(:fork) { |&block| ::Dry::Effects.yield(fork).(&block) }
        end
      end
    end
  end
end
