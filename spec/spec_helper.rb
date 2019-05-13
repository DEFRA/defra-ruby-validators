# frozen_string_literal: true

require "bundler/setup"

# Test coverage reporting
require "simplecov"
SimpleCov.start

# Support debugging in the tests
require "byebug"
# Load env vars from a text file
require "dotenv/load"
# Need to require our actual code files
Dir["./lib/defra_ruby/**/*.rb"].each { |file| require file }

# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. However in a small gem like this the increase should be neglible
Dir[File.join(__dir__, "support", "**", "*.rb")].each { |f| require f }

RSpec.configure do |config|
  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
