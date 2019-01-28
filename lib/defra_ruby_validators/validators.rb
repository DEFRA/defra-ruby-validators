# frozen_string_literal: true

require "active_model"
require "defra_ruby_validators/version"
require "defra_ruby_validators/companies_house_service"

require "defra_ruby_validators/companies_house_number_validator"

module DefraRubyValidators
  # Enable the ability to configure the gem from its host app, rather than
  # reading directly from env vars. Derived from
  # https://robots.thoughtbot.com/mygem-configure-block
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.configure
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
