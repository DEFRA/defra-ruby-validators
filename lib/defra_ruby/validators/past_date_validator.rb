# frozen_string_literal: true

module DefraRuby
  module Validators
    class PastDateValidator < BaseValidator
      def validate_each(record, attribute, value)
        return false if value.blank?

        date = value.to_date

        if date > Date.today
          record.errors[attribute] << error_message(:past_date)

          return false
        end

        if date.year < 1900
          record.errors[attribute] << error_message(:invalid_date)

          return false
        end

        true
      end
    end
  end
end
