# frozen_string_literal: true

Dry::Effects.load_extensions(:rspec)

RSpec.describe "rspec extension" do
  include Dry::Effects::Handler.Reader(:dummy)

  around { with_dummy(1, &_1) }

  example "current_example is available inside the handler" do
    expect(RSpec.current_example).not_to be_nil
  end
end
