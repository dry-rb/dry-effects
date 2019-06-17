# frozen_string_literal: true

require 'dry/effects/errors'

RSpec.describe Dry::Effects::Stack do
  let(:words_provider) do
    Dry::Effects.providers[:state].new(10, identifier: :words)
  end

  let(:chars_provider) do
    Dry::Effects.providers[:state].new(100, identifier: :chars)
  end

  let(:read_chars) { effect(:state, :read, :chars) }

  let(:read_words) { effect(:state, :read, :words) }

  describe '#push' do
    include Dry::Effects.State(:words)
    include Dry::Effects.State(:chars)

    let(:stack) { described_class.new }

    it 'combines two providers' do
      result = stack.push(words_provider) do
        stack.push(chars_provider) do
          expect(stack.size).to eql(2)
          expect(stack.provider(read_chars)).not_to be_nil
          expect(stack.provider(read_words)).not_to be_nil
          :done
        end
      end
      expect(result).to eql([10, [100, :done]])
    end
  end

  describe '#provider' do
    let(:providers) do
      [words_provider, chars_provider]
    end

    let(:stack) { described_class.new(providers) }

    it 'looks up provider for a given effect' do
      expect(stack.provider(read_chars)).to be(chars_provider)
    end
  end

  describe '#dup' do
    let(:providers) do
      [words_provider, chars_provider]
    end

    let(:stack) { described_class.new(providers) }

    let!(:copy) { stack.dup }

    it 'creates a copy of a stack' do
      chars_provider.write(200)
      expect(copy.(read_chars)).to eql(100)
    end
  end
end
