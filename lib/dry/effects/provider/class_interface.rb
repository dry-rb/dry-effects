# frozen_string_literal: true

require 'dry/core/class_attributes'

module Dry
  module Effects
    class Provider
      module ClassInterface
        def self.extended(base)
          base.instance_exec do
            defines :type

            @mutex = ::Mutex.new
            @effects = ::Hash.new do |es, type|
              @mutex.synchronize do
                es.fetch(type) do
                  es[type] = Class.new(Provider).tap do |provider|
                    provider.type type
                  end
                end
              end
            end
          end
        end

        include Core::ClassAttributes

        def [](type)
          @effects[type]
        end

        def mixin(*args, **kwargs)
          handle_method = handle_method(**kwargs)

          handler = handler(*args, **kwargs)

          ::Module.new do
            define_method(handle_method) do |init = Undefined, &block|
              handler.(init, &block)
            end
          end
        end

        def handler(*args, **kwargs)
          if kwargs.empty?
            Handler.new(self, args)
          else
            Handler.new(self, [*args, kwargs])
          end
        end

        def handle_method(as: Undefined, **)
          Undefined.default(as) { :"handle_#{type}" }
        end
      end
    end
  end
end
