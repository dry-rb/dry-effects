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

        def initialize(*keys, **aliases)
          module_eval do
            (keys.zip(keys) + aliases.to_a).each do |name, key|
              define_method(name) { |&block| ::Dry::Effects.yield(Resolve.(key), &block) }
            end
          end
        end
      end
    end
  end
end
