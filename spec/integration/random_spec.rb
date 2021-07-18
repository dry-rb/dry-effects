# frozen_string_literal: true

require "dry/effects/provider"

RSpec.describe "handling random" do
  include Dry::Effects::Handler.Random
  include Dry::Effects.Random

  context "default generator" do
    around { |ex| with_random(&ex) }

    context "integers" do
      it "returns integer when input is >= 1" do
        integers = Array.new(100) { rand(100) }
        expect(integers.all? { |i| i < 100 && i.is_a?(Integer) })
      end

      it "returns 0 for 1" do
        integers = Array.new(10) { rand(1) } # rubocop:disable Lint/RandOne
        expect(integers.all? { |i| i.equal?(0) })
      end
    end

    context "float" do
      it "uses input as an upper bound if it < 1" do
        floats = Array.new(100) { rand(0.5) }
        expect(floats.all? { |f| f < 0.5 && f >= 0.0 })
      end

      it "returns an integer if input >= 1" do
        integers = Array.new(100) { rand(10.5) }

        expect(integers.max).to eql(9)
        expect(integers.min).to eql(0)
      end
    end

    context "range" do
      context "integer..integer" do
        specify do
          integers = Array.new(100) { rand(0..10) }
          expect(integers.min).to eql(0)
          expect(integers.max).to eql(10)
        end
      end

      context "integer...integer" do
        specify do
          integers = Array.new(100) { rand(0...10) }
          expect(integers.min).to eql(0)
          expect(integers.max).to eql(9)
        end
      end

      context "float..float" do
        specify do
          floats = Array.new(100) { rand(0.0...0.5) }
          expect(floats.min).to be >= 0
          expect(floats.max).to be < 0.5
        end
      end

      context "float...float" do
        specify do
          floats = Array.new(100) { rand(0.0..0.5) }
          expect(floats.min).to be >= 0
          expect(floats.max).to be <= 0.5
        end
      end
    end

    it "relies on srand" do
      fixed_seed = ::Random.new_seed

      prev_seed = srand(fixed_seed)
      values_a = with_random { Array.new(10) { rand } }

      srand(fixed_seed)
      values_b = with_random { Array.new(10) { rand } }

      expect(values_a).to eql(values_b)

      srand(prev_seed)
    end
  end

  context "custom generator" do
    example "simple proc" do
      random_float = with_random(proc { 0.3 }) { rand }
      expect(random_float).to eql(0.3)

      random_int = with_random(proc { 0.5 }) { rand(10) }
      expect(random_int).to eql(5)
    end

    example "increasing values" do
      with_random(proc { |prev = 0.0| prev + 0.1 }) do
        expect(Array.new(11) { rand.round(1) }).to eql([
          0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1
        ])
      end

      with_random(proc { |prev = 0.0| prev + 0.1 }) do
        expect(Array.new(11) { rand(0.0...1.0).round(1) }).to eql([
          0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.1
        ])
      end
    end

    example "seed" do
      values_a = with_random(seed: 100) { Array.new(11) { rand } }
      values_b = with_random(seed: 100) { Array.new(11) { rand } }

      expect(values_a).to eql(values_b)
    end

    example "other options" do
      fixed_seed = ::Random.new_seed
      prev_seed = srand(fixed_seed)
      values_a = with_random({}) { Array.new(11) { rand } }

      srand(fixed_seed)
      values_b = with_random { Array.new(11) { rand } }

      expect(values_a).to eql(values_b)

      srand(prev_seed)
    end
  end
end
