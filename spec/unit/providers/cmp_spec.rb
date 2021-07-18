# frozen_string_literal: true

require "dry/effects/providers/cmp"

RSpec.describe Dry::Effects::Providers::Cmp do
  subject(:cmp) { described_class.new(id) }

  describe "#represent" do
    let(:id) { :feature }

    it "shows id and current state" do
      strings = cmp.() do
        cmp.represent
      end

      expect(strings).to eql(["cmp[feature=false]", "cmp[feature=true]"])
    end
  end
end
