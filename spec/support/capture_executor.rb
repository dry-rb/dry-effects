# frozen_string_literal: true

require 'concurrent/executor/executor_service'

class CaptureExecutor
  include Concurrent::ExecutorService

  def initialize
    @captured = []
  end

  def post(&block)
    @captured << block
  end

  def run_all
    @captured.each(&:call).clear
  end
end
