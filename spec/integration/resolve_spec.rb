# frozen_string_literal: true

RSpec.describe "resolving dependencies" do
  include Dry::Effects.Resolve(:foo, :bar)
  include Dry::Effects::Handler.Resolve

  example "passing dependencies" do
    result = provide(foo: 10, bar: 30) do
      foo + bar
    end

    expect(result).to be(40)
  end

  example "nesting deps" do
    result = provide(foo: 10) do
      provide(bar: 30) do
        foo + bar
      end
    end

    expect(result).to be(40)
  end

  context "overriding" do
    it "uses externally provided dependencies" do
      result = provide(foo: 10) do
        provide({ foo: 20 }, overridable: true) do
          foo
        end
      end

      expect(result).to be(10)
    end
  end

  it "uses fallback" do
    expect(foo { :fallback }).to be(:fallback)
  end

  describe "aliases" do
    include Dry::Effects.Resolve(baz: :foo)

    it "uses aliases" do
      provided = provide(foo: 10) { baz }
      expect(provided).to be(10)
    end
  end

  describe "constructors" do
    include Dry::Effects::Constructors

    example "building resolve effects" do
      expect(Resolve(:foo)).to eql(Dry::Effects::Effects::Resolve::Resolve.(:foo))
    end
  end
end
