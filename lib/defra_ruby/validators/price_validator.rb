# frozen_string_literal: true

module DefraRuby
  module Validators
    class PriceValidator < BaseValidator
      include CanValidatePresence

      def validate_each(record, attribute, value)
        return false unless value_is_present?(record, attribute, value)

        valid_format?(record, attribute, value)
      end

      private

      def valid_format?(record, attribute, value)
        return true if value.match?(/\A\d{1,10}(\.\d{1,2})?\z/)

        add_validation_error(record, attribute, :invalid_format)
        false
      end

    end
  end
end
