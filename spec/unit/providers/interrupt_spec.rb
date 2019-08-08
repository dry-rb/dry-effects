# frozen_string_literal: true

require 'dry/effects/providers/interrupt'

RSpec.describe Dry::Effects::Providers::Interrupt do
  subject(:interrupt) { described_class.new(:scope_name) }

  describe '#represent' do
    it 'shows the scope' do
      expect(interrupt.represent).to eql('interrupt[scope_name]')
    end
  end
end


