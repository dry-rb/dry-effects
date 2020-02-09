# frozen_string_literal: true

RSpec.describe 'ActiveSupport::TaggedLogging' do
  before(:all) { Dry::Effects.load_extensions(:active_support_tagged_logging) }

  include Dry::Effects::Handler.Reader(:context)

  before do
    extend ActiveSupport::TaggedLogging::Formatter
  end

  it 'keeps tags in presence of handlers' do
    tagged('foo', 'bar') do
      with_context(42) do
        expect(current_tags).to eql(%w(foo bar))
      end
    end
  end

  it 'stacks tags through handlers' do
    tagged('foo', 'bar') do
      with_context(42) do
        tagged('baz') do
          expect(current_tags).to eql(%w(foo bar baz))
        end
      end
    end
  end
end
