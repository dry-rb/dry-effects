# frozen_string_literal: true

require 'dry/effects/providers/defer'

RSpec.describe Dry::Effects::Providers::Defer do
  subject(:defer) { described_class.new }

  around { |ex| defer.(double(:stack), &ex) }

  describe '#dup' do
    it "prevents subsequent #later calls because it's not safe" do
      expect { defer.dup.later(double(:effect), double(:executor)).() }.to raise_error(
        Dry::Effects::Errors::EffectRejected,
        /\.later calls are not allowed/
      )
    end
  end
end
