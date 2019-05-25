require 'dry/effects/consumers/random'

RSpec.describe Dry::Effects do
  describe '.[]' do
    let(:mod) { described_class[*args] }

    let(:klass) do
      mod = self.mod
      Class.new do
        attr_reader :handler

        def initialize(handler)
          @handler = handler
        end

        include mod
      end
    end

    context 'random effect' do
      let(:handler) { Dry::Effects::Handler.new(:random, :kernel) }

      let(:args) { [:random] }

      before do
        klass.class_exec do
          def call
            handler.() do
              rand(10)
            end
          end
        end
      end

      it 'includes effects' do
        expect(klass.new(handler).()).to be < 10
      end
    end
  end
end
