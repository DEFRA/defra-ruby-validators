# frozen_string_literal: true

module DefraRubyValidators
  class TrueFalseValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
      return false unless value_is_present?(record, attribute, value)
      return false unless value_is_valid?(record, attribute, value)

      true
    end

    private

    def value_is_present?(record, attribute, value)
      return true if value.present?

      record.errors[attribute] << error_message("blank")
      false
    end

    def value_is_valid?(record, attribute, value)
      valid_values = %w[true false]
      return true if valid_values.include?(value)

      record.errors[attribute] << error_message("invalid")
      false
    end

    def error_message(error)
      I18n.t("defra_ruby_validators.true_false.errors.#{error}")
    end
  end
end
