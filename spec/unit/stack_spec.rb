# frozen_string_literal: true

require "dry/effects/errors"
require "dry/effects/effects/state"

RSpec.describe Dry::Effects::Stack do
  def state_effect(name, scope)
    Dry::Effects::Effects::State::State.new(
      type: :state, name: name, scope: scope
    )
  end

  let(:words_provider) do
    Dry::Effects.providers[:state].new(:words)
  end

  let(:chars_provider) do
    Dry::Effects.providers[:state].new(:chars)
  end

  let(:read_chars) { state_effect(:read, :chars) }

  let(:read_words) { state_effect(:read, :words) }

  describe "#push" do
    include Dry::Effects.State(:words)
    include Dry::Effects.State(:chars)

    let(:stack) { described_class.new }

    it "combines two providers" do
      result = stack.push(words_provider) do
        stack.push(chars_provider) do
          expect(stack.size).to eql(2)
          expect(stack.provider(read_chars)).not_to be_nil
          expect(stack.provider(read_words)).not_to be_nil
          :done
        end
      end
      expect(result).to be(:done)
    end
  end

  describe "#provider" do
    let(:providers) do
      [words_provider, chars_provider]
    end

    let(:stack) { described_class.new(providers) }

    it "looks up provider for a given effect" do
      expect(stack.provider(read_chars)).to be(chars_provider)
    end
  end

  describe "#dup" do
    let(:stack) { described_class.new }

    around do |ex|
      chars_provider.(100) do
        stack.push(chars_provider, &ex)
      end
    end

    it "creates a copy of a stack" do
      copy = stack.dup
      chars_provider.write(value: 200)
      expect(copy.(read_chars)).to eql(100)
    end
  end
end
