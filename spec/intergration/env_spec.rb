# frozen_string_literal: true

RSpec.describe 'env' do
  include Dry::Effects::Handler.Env
  include Dry::Effects.Env

  it 'provides environment values' do
    value = handle_env(foo: 'injected') { env(:foo) }

    expect(value).to eql('injected')
  end

  context 'ENV' do
    around do |ex|
      ENV['FOO'] = 'BAR'
      ex.run
      ENV.delete('FOO')
    end

    it 'uses values from ENV as a fallback' do
      value = handle_env { env('FOO') }

      expect(value).to eql('BAR')
    end
  end

  context 'reader methods' do
    describe 'sequential arguments' do
      include Dry::Effects.Env(:foo, :bar)

      example 'obtaining environment using methods' do
        handled = handle_env(foo: 'value_foo', bar: 'value_bar') do
          [foo, bar]
        end

        expect(handled).to eql(['value_foo', 'value_bar'])
      end
    end

    describe 'renamings' do
      context 'provided keys' do
        include Dry::Effects.Env(:foo, bar: :baz)

        example 'using renamed reader methods' do
          handled = handle_env(foo: 'value_foo', baz: 'value_bar') do
            [foo, bar]
          end

          expect(handled).to eql(['value_foo', 'value_bar'])
        end
      end
    end
  end
end
