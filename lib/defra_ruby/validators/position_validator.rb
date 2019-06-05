# frozen_string_literal: true

module DefraRuby
  module Validators
    class PositionValidator < BaseValidator
      include CanValidateCharacters
      include CanValidateLength

      def validate_each(record, attribute, value)
        # Position is an optional field so its immediately valid if it's blank
        return true if value.blank?
        return false unless value_has_no_invalid_characters?(record, attribute, value)

        max_length = 70
        value_is_not_too_long?(record, attribute, value, max_length)
        value_has_no_invalid_characters?(record, attribute, value)
      end

    end
  end
end
