# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :development, :test do
  gem "defra_ruby_style", "~> 0.3"
  gem "rspec-rails"
  # version 1.51. is problematic: https://github.com/intel/lkp-tests/commit/8268970ffefb91983e6d70785282759b7aa291fd
  gem "rubocop", "~> 1.50", require: false
  gem "rubocop-rspec", require: false
end

# Specify your gem's dependencies in defra_ruby_validators.gemspec
gemspec
