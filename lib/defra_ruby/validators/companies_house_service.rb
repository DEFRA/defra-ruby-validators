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
        return :not_found if @company_type && !company_type_is_allowed?(json_response["type"])

        status_is_allowed?(json_response["company_status"]) ? :active : :inactive
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

      def status_is_allowed?(status)
        %w[active voluntary-arrangement].include?(status)
      end

      def company_type_is_allowed?(company_type)
        @company_type.to_sym == company_type.to_sym
      end
    end
  end
end
