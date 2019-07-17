# frozen_string_literal: true

require 'dry/effects/providers/random'

RSpec.describe Dry::Effects do
  context 'without handlers' do
    before do
      extend Dry::Effects.Random
    end

    example 'raising an effect results in an error' do
      expect { rand(10) }.to raise_error(
        Dry::Effects::Errors::UnhandledEffectError,
        /not handled/
      )
    end
  end

  example 'reusing effect mixins' do
    conter_effects = Dry::Effects.State(:counter)
    expect(conter_effects).to be(Dry::Effects.State(:counter))
    expect(conter_effects).to be_frozen
  end
end
