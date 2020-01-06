# frozen_string_literal: true

require 'dry/effects/providers/retry'

RSpec.describe Dry::Effects::Providers::Retry do
  subject(:retry) { described_class.new(scope) }

  describe '#represent' do
    let(:scope) { :transaction }

    it 'shows scope and number of retries' do
      retries = 0
      strings = []

      self.retry.(10) do
        retries += 1
        strings << self.retry.represent
        self.retry.retry.() if retries <= 2
      end

      expect(strings).to eql([
                               'retry[transaction 1/10]',
                               'retry[transaction 2/10]',
                               'retry[transaction 3/10]'
                             ])
    end
  end
end
