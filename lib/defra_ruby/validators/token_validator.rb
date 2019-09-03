# frozen_string_literal: true

module DefraRuby
  module Validators
    class TokenValidator < BaseValidator
      include CanValidatePresence

      def validate_each(record, attribute, value)
        return false unless value_is_present?(record, attribute, value)

        valid_format?(record, attribute, value)
      end

      private

      def valid_format?(record, attribute, value)
        # The token is assumed to have been generated using
        # https://github.com/robertomiranda/has_secure_token which creates
        # 24-character unique tokens
        return true if value.length == 24

        record.errors[attribute] << error_message(:attribute, :invalid_format)
        false
      end
    end
  end
end
