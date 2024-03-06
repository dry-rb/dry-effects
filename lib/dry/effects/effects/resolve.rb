# frozen_string_literal: true

module Dry
  module Effects
    module Effects
      class Resolve < ::Module
        DependencyNameInvalid = ::Class.new(StandardError)

        VALID_NAME = /([a-z_][a-zA-Z_0-9]*)$/

        Resolve = Effect.new(type: :resolve)

        def initialize(*keys, **aliases)
          super()

          keys_aliased = keys.map { name_for(_1) }.zip(keys)
          module_eval do
            (keys_aliased + aliases.to_a).each do |name, key|
              define_method(name) { |&block| ::Dry::Effects.yield(Resolve.(key), &block) }
            end
          end
        end

        private

        # similar approach in dry-auto_inject https://github.com/dry-rb/dry-auto_inject/blob/master/lib/dry/auto_inject/dependency_map.rb#L42
        def name_for(identifier)
          matched = VALID_NAME.match(identifier.to_s)
          unless matched
            raise DependencyNameInvalid,
                  "name +#{identifier}+ is not a valid Ruby identifier"
          end

          matched[0]
        end
      end
    end
  end
end
