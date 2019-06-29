# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gemspec

group :test do
  gem 'simplecov', require: false, platform: :mri
end

group :tools do
  gem 'pry-byebug', platform: :mri
  gem 'rubocop'
end

gem 'dry-struct'
gem 'dry-monads'
