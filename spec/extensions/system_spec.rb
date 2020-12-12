# frozen_string_literal: true

RSpec.describe "dry-system extnesion" do
  before(:all) do
    Dry::Effects.load_extensions(:system)
  end

  include Dry::Effects::Handler.Reader(:operations)
  include Dry::Effects::Handler.Reader(:repos)

  let(:operations) { [] }
  let(:repos) { [] }

  around do |ex|
    with_operations(operations) do
      with_repos(repos, &ex)
    end
  end

  around do |ex|
    begin
      Test = Module.new
      load_path = $LOAD_PATH.dup
      features = $LOADED_FEATURES.dup
      require_relative "system/system/app"
      ex.run
    ensure
      $LOAD_PATH.replace(load_path)
      $LOADED_FEATURES.replace(features)
      Object.send(:remove_const, :Test)
    end
  end

  it "loads all depenencies without handler and order issues" do
    Test::App.finalize!

    expect(operations.size).to eql(1)
    expect(repos.size).to eql(1)
  end

  it "freezes values" do
    Test::App.finalize!

    expect(Test::App["operations.create_user"]).to be_frozen
  end

  it "returns self back" do
    expect(Test::App.finalize!).to be(Test::App)
  end
end
