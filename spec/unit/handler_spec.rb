# frozen_string_literal: true

RSpec.describe Dry::Effects::Handler do
  subject(:handler) { Dry::Effects[:random] }

  describe '#to_s' do
    specify do
      expect(handler.to_s).to eql('#<Dry::Effects::Handler random>')
    end
  end

  describe '#inspect' do
    specify do
      expect(handler.method(:inspect)).to eql(handler.method(:to_s))
    end
  end
end
