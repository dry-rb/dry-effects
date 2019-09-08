# frozen_string_literal: true

class Operation
  include Dry::Effects.State(:counter)
  include Dry::Effects.Cmp(:feature_enabled)

  def call
    if feature_enabled?
      self.counter += 10
      :with_feature
    else
      self.counter += 1
      :without_feature
    end
  end
end

module Handler
  include Dry::Effects::Handler.State(:counter, as: :with_counter)
  include Dry::Effects::Handler.Cmp(:feature_enabled, as: :test_feature)
end

class CmpState
  include Handler

  def initialize
    @operation = Operation.new
  end

  def call
    test_feature { with_counter(0) { @operation.call } }
  end
end

class StateCmp
  include Handler

  def initialize
    @operation = Operation.new
  end

  def call
    with_counter(0) { test_feature { @operation.call } }
  end
end

cmp_then_state = CmpState.new
state_then_cmp = State.Cmp.new

cmp_then_state.() # => [[1, :without_feature], [10, :with_feature]]
state_then_cmp.() # => [11, [:without_feature, :with_feature]]
