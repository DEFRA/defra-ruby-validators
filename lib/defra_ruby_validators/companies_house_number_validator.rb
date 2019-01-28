# frozen_string_literal: true

module DefraRubyValidators
  class CompaniesHouseNumberValidator < ActiveModel::EachValidator

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

      record.errors[attribute] << error_message("blank")
      false
    end

    def format_is_valid?(record, attribute, value)
      return true if value.match?(VALID_COMPANIES_HOUSE_REGISTRATION_NUMBER_REGEX)

      record.errors[attribute] << error_message("invalid")
      false
    end

    def validate_with_companies_house(record, attribute, value)
      case CompaniesHouseService.new(value).status
      when :active
        true
      when :inactive
        record.errors[attribute] << error_message("inactive")
      when :not_found
        record.errors[attribute] << error_message("not_found")
      end
    rescue StandardError
      record.errors[attribute] << error_message("error")
    end

    def error_message(error)
      I18n.t("defra_ruby_validators.companies_house_number.errors.#{error}")
    end

  end
end
