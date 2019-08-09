# frozen_string_literal: true

require 'dry/effects/providers/lock'

RSpec.describe Dry::Effects::Providers::Lock do
  subject(:lock) { described_class.new }

  describe '#represent' do
    specify('empty') { expect(lock.represent).to eql('lock') }

    context 'with locks' do
      before { lock.lock(:foo) }

      it 'shows the total number of locks acquired' do
        expect(lock.represent).to eql("lock[owned=#{1}]")
      end
    end
  end
end
