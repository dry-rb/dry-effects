# frozen_string_literal: true

require "dry-auto_inject"

RSpec.describe "dry-auto_inject extnesion" do
  before(:all) do
    Dry::Effects.load_extensions(:auto_inject)
  end

  let(:user_repo) { double(:user_repo) }

  let(:container) do
    Dry::Container.new.tap do |c|
      c.register("repos.user_repo", user_repo)
    end
  end

  let(:overridden_repo) { double(:overridden_repo) }

  let(:import) { Dry::Effects.AutoInject }

  let(:operation) do
    Class.new.tap { |klass|
      klass.include import["repos.user_repo"]
    }.new
  end

  let(:overriding_container) { {"repos.user_repo" => overridden_repo} }

  context "static resolution" do
    before do
      extend Dry::Effects::Handler.Resolve(container)
    end

    it "resolves dependencies" do
      provided = provide { operation.user_repo }
      expect(provided).to be(user_repo)
    end

    it "supports overriding" do
      provided = provide(overriding_container) { operation.user_repo }
      expect(provided).to be(overridden_repo)
    end

    it "caches result" do
      provided_before = provide(overriding_container) { operation.user_repo }
      provided_after = provide { operation.user_repo }
      expect(provided_before).to be(provided_after)
      expect(provided_after).to be(overridden_repo)
    end
  end

  context "static resolution with overriding from parent handler" do
    let(:parent_container) { overriding_container }

    before do
      extend Dry::Effects::Handler.Resolve(parent_container, as: :provide_parent)
      extend Dry::Effects::Handler.Resolve(container)
    end

    it "uses parent dep when possible" do
      provided = provide_parent { provide({}, overridable: true) { operation.user_repo } }

      expect(provided).to be(overridden_repo)
    end
  end

  context "dynamic resolution" do
    let(:import) { Dry::Effects.AutoInject(dynamic: true) }

    before do
      extend Dry::Effects::Handler.Resolve(container)
    end

    it "has no cache" do
      provided_before = provide(overriding_container) { operation.user_repo }
      provided_after = provide { operation.user_repo }
      expect(provided_before).to be(overridden_repo)
      expect(provided_after).to be(user_repo)
    end
  end

  context "dynamic resolution with overriding via parent container" do
    let(:import) { Dry::Effects.AutoInject(dynamic: true) }

    before do
      extend Dry::Effects::Handler.Resolve(container)
    end

    example do
      provided = provide(overriding_container) do
        provide({}, overridable: true) { operation.user_repo }
      end

      expect(provided).to be(overridden_repo)
    end
  end

  context "static resolution with constructor defined" do
    let(:operation) do
      import = self.import

      Class.new {
        include import["repos.user_repo"]

        def initialize(*)
          super
        end
      }.new
    end

    before do
      extend Dry::Effects::Handler.Resolve(container)
    end

    it "still works" do
      provided = provide(overriding_container) { operation.user_repo }
      expect(provided).to be(overridden_repo)
    end
  end
end
