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
    include Dry::Effects.Cache(:cached, as: :memoized)

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

      prepend Dry::Effects.Cache(:cached, as: :expensive)

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

      prepend Dry::Effects.Cache(:cached, as: :expensive)

      it 'uses arguments for cache' do
        result = with_cache do
          [expensive(:foo), expensive(:foo), expensive(:bar)]
        end

        expect(result).to eql(%i[foo_1 foo_1 bar_2])
        expect(@called).to be(2)
      end
    end
  end
end
