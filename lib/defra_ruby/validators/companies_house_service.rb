# frozen_string_literal: true

require "rest-client"

module DefraRuby
  module Validators
    class CompaniesHouseService
      def initialize(company_no, company_type = nil)
        @company_no = company_no
        @url = "#{DefraRuby::Validators.configuration.companies_house_host}#{@company_no}"
        @api_key = DefraRuby::Validators.configuration.companies_house_api_key
        @company_type = company_type
      end

      def status
        return :not_found unless company_type_is_allowed?(json_response)

        status_is_allowed?(json_response) ? :active : :inactive
      rescue RestClient::ResourceNotFound
        :not_found
      end

      def json_response
        @_json_response ||=
          JSON.parse(
            RestClient::Request.execute(
              method: :get,
              url: @url,
              user: @api_key,
              password: ""
            )
          )
      end

      private

      def status_is_allowed?(json_response)
        %w[active voluntary-arrangement].include?(json_response["company_status"])
      end

      def company_type_is_allowed?(json_response)
        # if a company_type has not been defined in the validator,
        # we skip this check
        return true if @company_type.blank?

        @company_type.to_s == json_response["type"]
      end
    end
  end
end
