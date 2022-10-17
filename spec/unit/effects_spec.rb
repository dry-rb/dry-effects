# frozen_string_literal: true

RSpec.describe Dry::Effects do
  describe ".yield" do
    example "with a fallback" do
      expect(Dry::Effects.yield(Object.new) { :fallback }).to be(:fallback)
    end
  end

  describe ".[]" do
    include Dry::Effects.CurrentTime

    it "builds an inline handler" do
      now = Time.now

      Dry::Effects[:current_time].(proc { now }) do
        expect(current_time).to be(now)
      end
    end
  end
end
