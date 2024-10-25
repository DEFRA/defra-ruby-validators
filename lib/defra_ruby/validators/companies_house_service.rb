# frozen_string_literal: true

require "rest-client"

module DefraRuby
  module Validators
    class CompaniesHouseService
      def initialize(company_number:, permitted_types: nil)
        @company_number = company_number
        @permitted_types = permitted_types

        validate_permitted_types

        @url = "#{DefraRuby::Validators.configuration.companies_house_host}#{@company_number}"
        @api_key = DefraRuby::Validators.configuration.companies_house_api_key
      end

      def status
        return :unsupported_company_type unless company_type_is_allowed?(json_response)

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

      def validate_permitted_types
        return if @permitted_types.nil?

        return if @permitted_types.is_a?(String) || @permitted_types.is_a?(Array)

        raise ArgumentError, I18n.t("defra_ruby.validators.CompaniesHouseNumberValidator.argument_error")
      end

      def status_is_allowed?(json_response)
        %w[active voluntary-arrangement].include?(json_response["company_status"])
      end

      def company_type_is_allowed?(json_response)
        # if permitted_types has not been defined in the validator, we skip this check
        return true if @permitted_types.blank?

        case @permitted_types
        when String
          @permitted_types.to_s == json_response["type"]
        when Array
          @permitted_types.include?(json_response["type"])
        else
          raise ArgumentError, I18n.t("defra_ruby.validators.CompaniesHouseNumberValidator.argument_error")
        end
      end
    end
  end
end
