# frozen_string_literal: true

require "phonelib"

module DefraRuby
  module Validators
    class MobilePhoneNumberValidator < BaseValidator
      include CanValidatePresence
      include CanValidateLength

      MAX_LENGTH = 15

      def validate_each(record, attribute, value)
        return false unless value_is_present?(record, attribute, value)
        return false unless value_is_not_too_long?(record, attribute, value, MAX_LENGTH)

        valid_format?(record, attribute, value)
      end

      private

      def valid_format?(record, attribute, value)
        Phonelib.default_country = "GB"
        return true if Phonelib.valid?(value) && Phonelib.parse(value).type == :mobile

        add_validation_error(record, attribute, :invalid_format)
        false
      end

    end
  end
end
