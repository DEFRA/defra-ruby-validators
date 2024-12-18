# frozen_string_literal: true

require "defra_ruby/companies_house"

module DefraRuby
  module Validators
    class CompaniesHouseService
      def initialize(company_number:, permitted_types: nil)
        @company_number = company_number
        @permitted_types = permitted_types

        validate_permitted_types
      end

      def status
        return :unsupported_company_type unless company_type_is_allowed?(companies_house_response)

        status_is_allowed?(companies_house_response) ? :active : :inactive
      rescue DefraRuby::CompaniesHouse::CompanyNotFoundError
        :not_found
      end

      private

      def companies_house_response
        @companies_house_response ||= DefraRuby::CompaniesHouse::API.run(company_number: @company_number)
      end

      def validate_permitted_types
        return if @permitted_types.nil?

        return if @permitted_types.is_a?(String) || @permitted_types.is_a?(Array)

        raise ArgumentError, I18n.t("defra_ruby.validators.CompaniesHouseNumberValidator.argument_error")
      end

      def status_is_allowed?(companies_house_response)
        %i[active voluntary-arrangement].include?(companies_house_response[:company_status])
      end

      def company_type_is_allowed?(companies_house_response)
        # if permitted_types has not been defined in the validator, we skip this check
        return true if @permitted_types.blank?

        case @permitted_types
        when String
          @permitted_types == companies_house_response[:company_type].to_s
        when Array
          @permitted_types.include?(companies_house_response[:company_type].to_s)
        else
          raise ArgumentError, I18n.t("defra_ruby.validators.CompaniesHouseNumberValidator.argument_error")
        end
      end
    end
  end
end
