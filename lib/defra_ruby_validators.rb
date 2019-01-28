# frozen_string_literal: true

require "defra_ruby_validators/version"

require "defra_ruby_validators/companies_house_service"

module DefraRubyValidators

  # Enable the ability to configure the gem from its host app, rather than
  # reading directly from env vars.
  # https://robots.thoughtbot.com/mygem-configure-block
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :companies_house_host, :companies_house_api_key

    def initialize
      @companies_house_host = "https://api.companieshouse.gov.uk/company/"
      @companies_house_api_key = nil
    end
  end
end
