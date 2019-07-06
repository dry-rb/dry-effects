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

          provider = new(*args, **kwargs).freeze
          handler = Handler.new(provider)

          ::Module.new do
            define_method(handle_method) do |*args, &block|
              handler.(args, &block)
            end
          end
        end

        def handle_method(as: Undefined, **)
          Undefined.default(as) { :"handle_#{type}" }
        end
      end
    end
  end
end
