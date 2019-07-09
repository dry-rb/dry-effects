# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dry/effects/version'

Gem::Specification.new do |spec|
  spec.name          = 'dry-effects'
  spec.version       = Dry::Effects::VERSION
  spec.authors       = ['Nikita Shilnikov']
  spec.email         = ['fg@flashgordon.ru']

  spec.summary       = 'Algebraic effects.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/dry-rb/dry-effects'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/dry-rb/dry-effects'
    spec.metadata['bug_tracker_uri'] = 'https://github.com/dry-rb/dry-effects/issues'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|bin)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'concurrent-ruby', '~> 1.0'
  spec.add_runtime_dependency 'dry-container', '~> 0.7', '>= 0.7.2'
  spec.add_runtime_dependency 'dry-core', '~> 0.4', '>= 0.4.7'
  spec.add_runtime_dependency 'dry-equalizer', '~> 0.2', '>= 0.2.2'
  spec.add_runtime_dependency 'dry-inflector', '~> 0.1', '>= 0.1.2'
  spec.add_runtime_dependency 'dry-initializer', '~> 3.0'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
