# frozen_string_literal: true

require 'dry/effects/effect'
require 'dry/effects/constructors'

module Dry
  module Effects
    module Effects
      class Resolve < ::Module
        Resolve = Effect.new(type: :resolve)

        def Constructors.Resolve(key)
          Resolve.(key)
        end

        def initialize(*keys)
          module_eval do
            keys.each do |key|
              define_method(key) { |&block| ::Dry::Effects.yield(Resolve.(key), &block) }
            end
          end
        end
      end
    end
  end
end
