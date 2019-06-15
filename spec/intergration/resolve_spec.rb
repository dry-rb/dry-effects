RSpec.describe 'resolving dependencies' do
  include Dry::Effects.Resolve(:foo, :bar)
  include Dry::Effects::Handler.Resolve(:foo, :bar)

  example 'passing dependencies' do
    result = provide(foo: 10, bar: 30) do
      foo + bar
    end

    expect(result).to be(40)
  end

  example 'nesting deps' do
    result = provide(foo: 10) do
      provide(bar: 30) do
        foo + bar
      end
    end

    expect(result).to be(40)
  end
end
