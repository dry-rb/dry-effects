# frozen_string_literal: true

source "https://rubygems.org"

eval_gemfile "Gemfile.devtools"

gemspec

group :test do
  gem "activesupport"
  gem "dry-auto_inject", require: false
  gem "dry-system"
end

group :tools do
  gem "pry-byebug", platform: :mri
end

gem "dry-struct"
gem "dry-monads"
