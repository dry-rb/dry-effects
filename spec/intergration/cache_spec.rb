# frozen_string_literal: true

require 'dry/effects/handler'

RSpec.describe 'handling cache' do
  include Dry::Effects::Handler.Cache(:cached)
  include Dry::Effects.Cache(:cached)

  example 'fetching cached values' do
    result = with_cache do
      [
        cache([1, 2, 3]) { :foo },
        cache([1, 2, 3]) { :bar },
        cache([2, 3, 4]) { :baz }
      ]
    end

    expect(result).to eql(%i[foo foo baz])
  end

  context 'alias' do
    include Dry::Effects.Cache(cached: :memoized)

    it 'uses given alias' do
      result = with_cache do
        [
          memoized([1, 2, 3]) { :foo },
          memoized([1, 2, 3]) { :bar }
        ]
      end

      expect(result).to eql(%i[foo foo])
    end
  end

  context 'prepending' do
    before { @called = 0 }

    context '0 arity' do
      def expensive
        @called += 1
        :foo
      end

      prepend Dry::Effects.Cache(cached: :expensive)

      it 'caches result after first super call' do
        result = with_cache do
          [expensive, expensive]
        end

        expect(result).to eql(%i[foo foo])
        expect(@called).to be(1)
      end
    end

    context 'with arguments' do
      def expensive(val)
        @called += 1
        :"#{val}_#{@called}"
      end

      prepend Dry::Effects.Cache(cached: :expensive)

      it 'uses arguments for cache' do
        result = with_cache do
          [expensive(:foo), expensive(:foo), expensive(:bar)]
        end

        expect(result).to eql(%i[foo_1 foo_1 bar_2])
        expect(@called).to be(2)
      end
    end

    context 'clashing' do
      attr_accessor :called

      let(:cache_module) { Dry::Effects.Cache(cached: %i(expensive slow)) }

      let(:operation_a) do
        ex = self
        Class.new {
          prepend ex.cache_module

          define_method(:expensive) do |val|
            ex.called += 1

            :"#{val}_a"
          end

          define_method(:slow) do |val|
            ex.called += 1

            :"slow_#{val}_a"
          end
        }.new
      end

      let(:operation_b) do
        ex = self
        Class.new {
          prepend ex.cache_module

          define_method(:expensive) do |val|
            ex.called += 1
            :"#{val}_b"
          end

          define_method(:slow) do |val|
            ex.called += 1

            :"slow_#{val}_b"
          end
        }.new
      end

      it 'uses per-class and per-method cache by default' do
        self.called = 0

        result = with_cache do
          [
            operation_a.expensive(:foo),
            operation_b.expensive(:foo),
            operation_a.expensive(:foo),
            operation_b.expensive(:foo),
            operation_a.slow(:foo),
            operation_b.slow(:foo),
            operation_a.slow(:foo),
            operation_b.slow(:foo)
          ]
        end

        expect(result).to eql(%i[
          foo_a foo_b
          foo_a foo_b
          slow_foo_a slow_foo_b
          slow_foo_a slow_foo_b
        ])
        expect(called).to be(4)
      end

      context 'sharing' do
        let(:cache_module) { Dry::Effects.Cache({ cached: :expensive }, shared: true) }

        it 'can be shared' do
          self.called = 0

          result = with_cache do
            [
              operation_a.expensive(:foo),
              operation_b.expensive(:foo),
              operation_a.expensive(:foo),
              operation_b.expensive(:foo)
            ]
          end

          expect(result).to eql(%i[foo_a foo_a foo_a foo_a])
          expect(called).to be(1)
        end
      end
    end
  end

  context 'clasing' do
    attr_accessor :called

    let(:cache_module) { Dry::Effects.Cache(:cached) }

    let(:operation_a) do
      ex = self
      Class.new {
        include ex.cache_module

        define_method(:expensive) do |val|
          cache(val) do
            ex.called += 1
            :"#{val}_a"
          end
        end
      }.new
    end

    let(:operation_b) do
      ex = self
      Class.new {
        include ex.cache_module

        define_method(:expensive) do |val|
          cache(val) do
            ex.called += 1
            :"#{val}_b"
          end
        end
      }.new
    end

    example 'cache is not shared by default' do
      self.called = 0

      result = with_cache do
        [
          operation_a.expensive(:foo),
          operation_b.expensive(:foo),
          operation_a.expensive(:foo),
          operation_b.expensive(:foo)
        ]
      end

      expect(result).to eql(%i[foo_a foo_b foo_a foo_b])
      expect(called).to be(2)
    end

    context 'sharing' do
      let(:cache_module) { Dry::Effects.Cache(:cached, shared: true) }

      it 'can be shared' do
        self.called = 0

        result = with_cache do
          [
            operation_a.expensive(:foo),
            operation_b.expensive(:foo),
            operation_a.expensive(:foo),
            operation_b.expensive(:foo)
          ]
        end

        expect(result).to eql(%i[foo_a foo_a foo_a foo_a])
        expect(called).to be(1)
      end
    end
  end
end
