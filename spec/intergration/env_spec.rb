# frozen_string_literal: true

RSpec.describe 'env' do
  include Dry::Effects::Handler.Env
  include Dry::Effects.Env

  it 'provides environment values' do
    value = with_env(foo: 'injected') { env(:foo) }

    expect(value).to eql('injected')
  end

  context 'ENV' do
    around do |ex|
      ENV['FOO'] = 'BAR'
      ex.run
      ENV.delete('FOO')
    end

    it 'uses values from ENV as a fallback' do
      value = with_env { env('FOO') }

      expect(value).to eql('BAR')
    end
  end

  context 'reader methods' do
    describe 'sequential arguments' do
      include Dry::Effects.Env(:foo, :bar)

      example 'obtaining environment using methods' do
        handled = with_env(foo: 'value_foo', bar: 'value_bar') do
          [foo, bar]
        end

        expect(handled).to eql(['value_foo', 'value_bar'])
      end
    end

    describe 'renamings' do
      context 'provided keys' do
        include Dry::Effects.Env(:foo, bar: :baz)

        example 'using renamed reader methods' do
          handled = with_env(foo: 'value_foo', baz: 'value_bar') do
            [foo, bar]
          end

          expect(handled).to eql(['value_foo', 'value_bar'])
        end
      end
    end
  end

  context 'static env' do
    include Dry::Effects::Handler.Env(foo: :bar)
    include Dry::Effects.Env(:foo)

    it 'uses static values' do
      expect(with_env { foo }).to be(:bar)
    end
  end

  context 'overridding' do
    context 'user-provided values' do
      include Dry::Effects::Handler.Env
      include Dry::Effects.Env(:foo)

      it 'can be overridden by providing a handle option' do
        handled = with_env(foo: 'external') do
          with_env({ foo: 'internal' }, overridable: true) do
            foo
          end
        end

        expect(handled).to eql('external')
      end
    end

    context 'ENV' do
      include Dry::Effects.Env(env: 'RACK_ENV')

      before { ENV['RACK_ENV'] = 'test' }

      it 'can be overridden' do
        handled = with_env('RACK_ENV' => 'production') do
          with_env({}, overridable: true) do
            env
          end
        end

        expect(handled).to eql('production')
      end
    end
  end
end
