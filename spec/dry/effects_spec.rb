require 'dry/effects/providers/random'

RSpec.describe Dry::Effects do
  context 'without handlers' do
    before do
      extend Dry::Effects.Random
    end

    example 'raising an effect results in an error' do
      expect { rand(10) }.to raise_error(
        Dry::Effects::Errors::UnhandledEffect,
        /not handled/
      )
    end
  end
end
