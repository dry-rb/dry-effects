# frozen_string_literal: true

# this file is synced from dry-rb/template-gem project

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dry/effects/version"

Gem::Specification.new do |spec|
  spec.name          = "dry-effects"
  spec.authors       = ["Nikita Shilnikov"]
  spec.email         = ["fg@flashgordon.ru"]
  spec.license       = "MIT"
  spec.version       = Dry::Effects::VERSION.dup

  spec.summary       = "Algebraic effects"
  spec.description   = spec.summary
  spec.homepage      = "https://dry-rb.org/gems/dry-effects"
  spec.files         = Dir["CHANGELOG.md", "LICENSE", "README.md", "dry-effects.gemspec", "lib/**/*"]
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["changelog_uri"]     = "https://github.com/dry-rb/dry-effects/blob/main/CHANGELOG.md"
  spec.metadata["source_code_uri"]   = "https://github.com/dry-rb/dry-effects"
  spec.metadata["bug_tracker_uri"]   = "https://github.com/dry-rb/dry-effects/issues"

  spec.required_ruby_version = ">= 2.7.0"

  # to update dependencies edit project.yml
  spec.add_runtime_dependency "concurrent-ruby", "~> 1.0"
  spec.add_runtime_dependency "dry-configurable"
  spec.add_runtime_dependency "dry-container", "~> 0.7", ">= 0.7.2"
  spec.add_runtime_dependency "dry-core", "~> 0.5", ">= 0.5"
  spec.add_runtime_dependency "dry-inflector", "~> 0.1", ">= 0.1.2"
  spec.add_runtime_dependency "dry-initializer", "~> 3.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
