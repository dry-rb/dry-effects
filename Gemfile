# frozen_string_literal: true

source "https://rubygems.org"

eval_gemfile "Gemfile.devtools"

gemspec

gem "dry-container", github: "dry-rb/dry-container", branch: "main"
gem "dry-core", github: "dry-rb/dry-core", branch: "main"

group :test do
  gem "activesupport"
  gem "dry-auto_inject", require: false
  gem "dry-system", github: "dry-rb/dry-system", branch: "main"
end

group :tools do
  gem "pry-byebug", platform: :mri
end

gem "dry-monads"
gem "dry-struct"
