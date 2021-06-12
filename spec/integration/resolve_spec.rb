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

  describe "nested names" do
    include Dry::Effects.Resolve("name.space.foo", "name/space/foo1", "name-space-foo2")

    it "uses last name" do
      provided = provide("name.space.foo" => 10, "name/space/foo1" => 10, "name-space-foo2" => 10) { foo + foo1 + foo2 }
      expect(provided).to be(30)
    end
  end

  it "raise when Ruby identifier is invalid name" do
    expect { include Dry::Effects.Resolve("-/foo/-") }.to raise_error(
      Dry::Effects::Effects::Resolve::DependencyNameInvalid,
      "name +-/foo/-+ is not a valid Ruby identifier"
    )
  end

  describe "constructors" do
    include Dry::Effects::Constructors

    example "building resolve effects" do
      expect(Resolve(:foo)).to eql(Dry::Effects::Effects::Resolve::Resolve.(:foo))
    end
  end
end
