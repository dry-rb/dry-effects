# frozen_string_literal: true

# These patches make those rspec parts depending on Thread.current
# play nice with dry-effects.
# They've been used in production for months before been added here.

RSpec::Support.singleton_class.prepend(Module.new {
  include Dry::Effects.Reader(:rspec, as: :effect_local_data)

  def thread_local_data
    effect_local_data { super }
  end
})

RSpec::Core::Runner.prepend(Module.new {
  include Dry::Effects::Handler.Reader(:rspec, as: :run_with_data)

  def run_specs(*)
    run_with_data(RSpec::Support.thread_local_data) { super }
  end
})
