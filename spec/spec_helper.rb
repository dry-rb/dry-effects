# frozen_string_literal: true

require "bundler/setup"

require_relative "support/coverage"
require_relative "support/warnings"
require_relative "support/rspec_options"

begin
  require "pry-byebug"
rescue LoadError
end

require "pathname"

SPEC_ROOT = Pathname(__FILE__).dirname
Dir[SPEC_ROOT.join("support/**/*.rb")].each(&method(:require))

require "dry/effects"

Warning.ignore(/codacy/)
Warning.ignore(/dry-system/)
Warning.ignore(/dry-configurable/)
Warning.ignore(/__LINE__/)
Warning.ignore(/__FILE__/)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
