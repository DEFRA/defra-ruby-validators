# frozen_string_literal: true

module DefraRuby
  module Validators
    class CompaniesHouseNumberValidator < BaseValidator

      # Examples we need to validate are
      # 10997904, 09764739
      # SC534714, CE000958
      # IP00141R, IP27702R, SP02252R
      # https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/426891/uniformResourceIdentifiersCustomerGuide.pdf
      VALID_COMPANIES_HOUSE_REGISTRATION_NUMBER_REGEX = Regexp.new(
        /\A(\d{8,8}$)|([a-zA-Z]{2}\d{6}$)|([a-zA-Z]{2}\d{5}[a-zA-Z]{1}$)\z/i
      ).freeze

      def validate_each(record, attribute, value)
        return false unless value_is_present?(record, attribute, value)
        return false unless format_is_valid?(record, attribute, value)

        validate_with_companies_house(record, attribute, value)
      end

      private

      def value_is_present?(record, attribute, value)
        return true if value.present?

        add_validation_error(record, attribute, :blank)
        false
      end

      def format_is_valid?(record, attribute, value)
        return true if value.match?(VALID_COMPANIES_HOUSE_REGISTRATION_NUMBER_REGEX)

        add_validation_error(record, attribute, :invalid_format)
        false
      end

      def validate_with_companies_house(record, attribute, value)
        case CompaniesHouseService.new(value).status
        when :active
          true
        when :inactive
          add_validation_error(record, attribute, :inactive)
        when :not_found
          add_validation_error(record, attribute, :not_found)
        end
      rescue StandardError
        add_validation_error(record, attribute, :error)
      end

    end
  end
end
