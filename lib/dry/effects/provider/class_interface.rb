# frozen_string_literal: true

require "dry/effects/frame"

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

        attr_reader :effects

        def [](type)
          if self < Provider
            Provider.effects.fetch(type) do
              Provider.effects[type] = ::Class.new(self).tap do |subclass|
                subclass.type type
              end
            end
          else
            @effects[type]
          end
        end

        def mixin(*as, **kw)
          handle_method = handle_method(*as, **kw)

          provider = new(*as, **kw).freeze
          frame = Frame.new(provider)

          ::Module.new do
            define_method(handle_method) do |*args, &block|
              frame.(*args, &block)
            end
          end
        end

        def handle_method(*, as: Undefined, **)
          Undefined.default(as) { :"with_#{type}" }
        end
      end
    end
  end
end
