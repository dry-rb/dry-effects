# frozen_string_literal: true

require "active_support/tagged_logging"

ActiveSupport::TaggedLogging::Formatter.prepend(Module.new {
  def current_tags
    thread_key = @thread_key ||= "activesupport_tagged_logging_tags:#{object_id}"
    unless Thread.current.thread_variable_get(thread_key)
      Thread.current.thread_variable_set(thread_key, [])
    end
    Thread.current.thread_variable_get(thread_key)
  end
})
