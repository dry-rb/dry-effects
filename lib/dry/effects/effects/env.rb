# frozen_string_literal: true

module Dry
  module Effects
    module Effects
      class Env < ::Module
        Read = Effect.new(type: :env, name: :read)

        def initialize(*args, **kwargs)
          super()

          readers = args.zip(args) + kwargs.to_a

          module_eval do
            if readers.empty?
              define_method(:env) do |key|
                ::Dry::Effects.yield(Read.(key))
              end
            else
              readers.each do |reader, key|
                define_method(reader) do
                  ::Dry::Effects.yield(Read.payload(key))
                end
              end
            end
          end
        end
      end
    end
  end
end
