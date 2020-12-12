# frozen_string_literal: true

Dry::Effects.load_extensions(:rspec)

RSpec.describe "rspec extension" do
  include Dry::Effects::Handler.Reader(:dummy)

  around { |ex| with_dummy(1, &ex) }

  example "current_example is available inside the handler" do
    expect(RSpec.current_example).not_to be_nil
  end
end
