# frozen_string_literal: true

require 'dry/effects/providers/amb'

RSpec.describe Dry::Effects::Providers::Amb do
  subject(:amb) { described_class.new(id) }

  describe '#represent' do
    let(:id) { :feature }

    it 'shows id and current state' do
      strings = amb.(double(:stack)) do
        amb.represent
      end

      expect(strings).to eql(['amb[feature=false]', 'amb[feature=true]'])
    end
  end
end


