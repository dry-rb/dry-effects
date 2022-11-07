# frozen_string_literal: true

source "https://rubygems.org"

eval_gemfile "Gemfile.devtools"

gemspec

group :test do
  gem "activesupport"
  gem "dry-auto_inject", "1.0.0.rc1", require: false
  gem "dry-logic"
  gem "dry-types"
  gem "dry-system", "1.0.0.rc1"
end

group :tools do
  gem "pry-byebug", platform: :mri
end
