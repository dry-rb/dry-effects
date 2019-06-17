# frozen_string_literal: true

require 'dry/effects/handler'

module Dry
  module Effects
    module Effects
      class Fork < ::Module
        def initialize(_ = Undefined)
          define_method(:fork) { |&block| ::Dry::Effects.yield(Handler::FORK).(&block) }
        end
      end
    end
  end
end
