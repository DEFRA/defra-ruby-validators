# frozen_string_literal: true

# Stubbing HTTP requests
require "webmock/rspec"
# Auto generate fake responses for web-requests
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock

  c.ignore_hosts "127.0.0.1", "codeclimate.com"

  SECONDS_IN_DAY = 24 * 60 * 60

  c.default_cassette_options = { re_record_interval: (14 * SECONDS_IN_DAY) }

  # Strip out authorization info
  c.filter_sensitive_data("Basic <API_KEY>") do |interaction|
    auth = interaction.request.headers["Authorization"]
    auth.first if auth.nil? || auth.empty?
  end
end
