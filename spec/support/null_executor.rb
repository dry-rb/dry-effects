# frozen_string_literal: true

require "singleton"
require "concurrent/executor/executor_service"

class NullExecutor
  include Singleton
  include Concurrent::ExecutorService

  def post; end
end
