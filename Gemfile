# frozen_string_literal: true

source "https://rubygems.org"

eval_gemfile "Gemfile.devtools"

gemspec

gem "dry-core", github: "dry-rb/dry-core", branch: "main"

group :test do
  gem "activesupport"
  gem "dry-auto_inject", github: "dry-rb/dry-auto_inject", branch: "main", require: false
  gem "dry-logic", github: "dry-rb/dry-logic", branch: "main"
  gem "dry-types", github: "dry-rb/dry-types", branch: "main"
  gem "dry-system", github: "dry-rb/dry-system", branch: "main"
end

group :tools do
  gem "pry-byebug", platform: :mri
end

gem "dry-configurable", github: "dry-rb/dry-configurable", branch: "main"
gem "dry-inflector", github: "dry-rb/dry-inflector", branch: "main"
gem "dry-monads", github: "dry-rb/dry-monads", branch: "main"
gem "dry-struct", github: "dry-rb/dry-struct", branch: "main"
