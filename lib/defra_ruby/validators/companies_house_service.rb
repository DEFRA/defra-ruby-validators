# frozen_string_literal: true

require "rest-client"

module DefraRuby
  module Validators
    class CompaniesHouseService
      def initialize(company_no)
        @company_no = company_no
        @url = "#{DefraRuby::Validators.configuration.companies_house_host}#{@company_no}"
        @api_key = DefraRuby::Validators.configuration.companies_house_api_key
      end

      def status
        response = RestClient::Request.execute(
          method: :get,
          url: @url,
          user: @api_key,
          password: ""
        )

        json = JSON.parse(response)

        status_is_allowed?(json["company_status"]) ? :active : :inactive
      rescue RestClient::ResourceNotFound
        :not_found
      end

      private

      def status_is_allowed?(status)
        %w[active voluntary-arrangement].include?(status)
      end
    end
  end
end
