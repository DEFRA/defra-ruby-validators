# frozen_string_literal: true

module DefraRuby
  module Validators
    class PastDateValidator < BaseValidator
      def validate_each(record, attribute, value)
        return false if value.blank?

        date = value.to_date

        if date > Date.today
          add_validation_error(record, attribute, :past_date)

          return false
        end

        if date.year < 1900
          add_validation_error(record, attribute, :invalid_date)

          return false
        end

        true
      end
    end
  end
end
