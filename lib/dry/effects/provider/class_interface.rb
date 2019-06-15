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

        def mixin(identifier = Undefined, *args, **kwargs)
          handler = handler(identifier, *args, **kwargs)

          handle_method = handle_method(identifier, *args, **kwargs)

          ::Module.new do
            define_method(handle_method) { |init = Undefined, &block| handler.(init, &block) }
          end
        end

        def handler(identifier = Undefined, *args, **kwargs)
          Handler.new(self, identifier)
        end

        def handle_method(identifier = Undefined, *, as: Undefined, **)
          Undefined.default(as) do
            if Undefined.equal?(identifier)
              :"handle_#{type}"
            else
              :"handle_#{identifier}"
            end
          end
        end
      end
    end
  end
end
