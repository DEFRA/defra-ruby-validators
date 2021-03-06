# frozen_string_literal: true

module DefraRuby
  module Validators
    class PositionValidator < BaseValidator
      include CanValidateCharacters
      include CanValidateLength

      MAX_LENGTH = 70

      def validate_each(record, attribute, value)
        # Position is an optional field so its immediately valid if it's blank
        return true if value.blank?
        return false unless value_has_no_invalid_characters?(record, attribute, value)

        value_is_not_too_long?(record, attribute, value, MAX_LENGTH)
        value_has_no_invalid_characters?(record, attribute, value)
      end

    end
  end
end
