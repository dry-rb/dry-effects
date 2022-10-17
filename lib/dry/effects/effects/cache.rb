# frozen_string_literal: true

module Dry
  module Effects
    module Effects
      class Cache < ::Module
        class CacheEffect < Effect
          option :scope
        end

        def initialize(scope = nil, shared: false, **kw)
          super()

          if !kw.empty?
            scope, as = kw.to_a[0]
          elsif scope.is_a?(::Hash)
            scope, as = scope.to_a[0]
          else
            as = :cache
          end

          fetch_or_store = CacheEffect.new(
            type: :cache,
            name: :fetch_or_store,
            scope: scope
          )

          key = key(shared)

          module_eval do
            Array(as).each do |meth|
              define_method(meth) do |*args, &block|
                if block
                  eff = fetch_or_store.(key.(self, args), block)
                else
                  eff = fetch_or_store.(key.(self, args, method: meth), -> { super(*args) })
                end

                ::Dry::Effects.yield(eff)
              end
            end
          end
        end

        def key(shared)
          if shared
            method(:shared_cache_key)
          else
            method(:cache_key)
          end
        end

        def shared_cache_key(_, args, method: Undefined)
          if Undefined.equal?(method)
            args
          else
            [method, args]
          end
        end

        def cache_key(instance, args, method: Undefined)
          if Undefined.equal?(method)
            [instance, args]
          else
            [instance, method, args]
          end
        end
      end
    end
  end
end
