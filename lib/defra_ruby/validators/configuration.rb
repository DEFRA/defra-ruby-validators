# frozen_string_literal: true

module DefraRuby
  module Validators
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      ATTRIBUTES = %i[
        companies_house_host
        companies_house_api_key
      ].freeze

      attr_accessor(*ATTRIBUTES)

      def initialize
        @companies_house_host = "https://api.companieshouse.gov.uk/company/"
        @companies_house_api_key = nil
      end

      def ensure_valid
        missing_attributes = ATTRIBUTES.select { |a| public_send(a).nil? }
        return true if missing_attributes.empty?

        raise "The following DefraRuby::Validators configuration attributes are missing: #{missing_attributes}"
      end
    end
  end
end
