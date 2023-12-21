# frozen_string_literal: true

require "uk_postcode"

module DefraRuby
  module Validators
    class PostcodeValidator < BaseValidator
      include CanValidatePresence

      def validate_each(record, attribute, value)
        return false unless value_is_present?(record, attribute, value)

        valid_format?(record, attribute, value)
      end

      private

      def valid_format?(record, attribute, value)
        parsed_value = UKPostcode.parse(value)
        return true if (normalise(parsed_value) == normalise(value)) && parsed_value.full_valid?

        add_validation_error(record, attribute, :invalid_format)
        false
      end

      def normalise(postcode)
        postcode.to_s.downcase.gsub(/\s+/, "")
      end
    end
  end
end
