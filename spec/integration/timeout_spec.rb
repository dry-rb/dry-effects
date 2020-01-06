# frozen_string_literal: true

RSpec.describe 'handling timeout' do
  include Dry::Effects::Handler.Timeout(:request)
  include Dry::Effects.Timeout(:request)

  it 'runs out' do
    with_timeout(5) do
      expect(timeout).to be < 5.0
      expect(timeout).to be > 4.5
      expect(timeout).to be > timeout
    end
  end

  it 'has a predicate method' do
    with_timeout(1.0) { expect(timed_out?).to be(false) }
    with_timeout(0) { expect(timed_out?).to be(true) }
  end
end
