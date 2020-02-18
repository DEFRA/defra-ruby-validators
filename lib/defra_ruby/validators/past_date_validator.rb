# frozen_string_literal: true

module DefraRuby
  module Validators
    class PastDateValidator < BaseValidator
      def validate_each(record, attribute, value)
        return false if value.blank?

        return true if value.to_date <= Date.today

        record.errors[attribute] << error_message(:past_date)

        false
      end
    end
  end
end
