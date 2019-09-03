# frozen_string_literal: true

require "os_map_ref"

module DefraRuby
  module Validators
    class GridReferenceValidator < BaseValidator
      include CanValidatePresence

      def validate_each(record, attribute, value)
        return false unless value_is_present?(record, attribute, value)
        return false unless valid_format?(record, attribute, value)

        valid_coordinate?(record, attribute, value)
      end

      private

      # Note that OsMapRef will work with less specific coordinates than are
      # required for this service (100m) - so we need to add an additional check
      # rather than just jump straight to confirming if it's a valid coordinate
      def valid_format?(record, attribute, value)
        return true if value.match?(/\A#{grid_reference_pattern}\z/)

        record.errors[attribute] << error_message(:attribute, :invalid_format)
        false
      end

      def valid_coordinate?(record, attribute, value)
        OsMapRef::Location.for(value).easting
        true
      rescue OsMapRef::Error
        record.errors[attribute] << error_message(:attribute, :invalid)
        false
      end

      def grid_reference_pattern
        [two_letters, optional_space, five_digits, optional_space, five_digits].join
      end

      def two_letters
        "[A-Za-z]{2}"
      end

      def five_digits
        '\d{5}'
      end

      def optional_space
        '\s*'
      end

    end
  end
end
