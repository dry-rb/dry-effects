# frozen_string_literal: true

require 'dry/effects/providers/resolve'

RSpec.describe Dry::Effects::Providers::Resolve do
  let(:static) { {} }

  subject(:resolve) { described_class.new(static) }

  describe '#represent' do
    context 'when static container is empty' do
      context 'when dynamic container is not set' do
        specify do
          expect(resolve.represent).to eql('resolve[empty]')
        end
      end

      context 'dynamic container is provided' do
        example 'empty hash' do
          resolve.() do
            expect(resolve.represent).to eql('resolve[empty]')
          end
        end

        example 'not empty hash' do
          resolve.({ foo: :bar }) do
            expect(resolve.represent).to eql('resolve[hash]')
          end
        end

        example 'a class' do
          resolve.(stub_const('Container', Class.new)) do
            expect(resolve.represent).to eql('resolve[Container]')
          end
        end
      end
    end

    context 'when static container is a hash' do
      let(:static) { { foo: :bar } }

      context 'when dynamic container is not set' do
        specify do
          expect(resolve.represent).to eql('resolve[hash]')
        end
      end

      context 'dynamic container is provided' do
        example 'empty hash' do
          resolve.() do
            expect(resolve.represent).to eql('resolve[hash]')
          end
        end

        example 'not empty hash' do
          resolve.({ foo: :bar }) do
            expect(resolve.represent).to eql('resolve[hash+hash]')
          end
        end

        example 'a class' do
          resolve.(stub_const('Container', Class.new)) do
            expect(resolve.represent).to eql('resolve[hash+Container]')
          end
        end
      end
    end

    context 'when static container is a class' do
      let(:static) { stub_const('Container', Class.new) }

      context 'when dynamic container is not set' do
        specify do
          expect(resolve.represent).to eql('resolve[Container]')
        end
      end

      context 'dynamic container is provided' do
        example 'empty hash' do
          resolve.() do
            expect(resolve.represent).to eql('resolve[Container]')
          end
        end

        example 'not empty hash' do
          resolve.({ foo: :bar }) do
            expect(resolve.represent).to eql('resolve[Container+hash]')
          end
        end
      end
    end
  end
end
