# frozen_string_literal: true

source "https://rubygems.org"

eval_gemfile "Gemfile.devtools"

gemspec

group :test do
  gem "activesupport"
  gem "dry-auto_inject", require: false
  gem "dry-configurable", github: "dry-rb/dry-configurable"
  gem "dry-system", "~> 0.19.0"
end

group :tools do
  gem "pry-byebug", platform: :mri
end

gem "dry-monads"
gem "dry-struct"
