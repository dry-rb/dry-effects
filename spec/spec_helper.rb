# frozen_string_literal: true

require 'bundler/setup'

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

begin
  require 'pry-byebug'
rescue LoadError
end

require 'pathname'

SPEC_ROOT = Pathname(__FILE__).dirname
Dir[SPEC_ROOT.join('support/**/*.rb')].each(&method(:require))

require 'dry/effects'
require 'warning'

Warning.ignore(/dry-system/)
Warning.ignore(/dry-configurable/)
Warning.ignore(/__LINE__/)
Warning.ignore(/__FILE__/)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.filter_run_when_matching :focus

  config.warnings = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
