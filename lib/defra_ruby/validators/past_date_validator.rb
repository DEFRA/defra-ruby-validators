# frozen_string_literal: true

module DefraRuby
  module Validators
    class PastDateValidator < BaseValidator
      def validate_each(record, attribute, value)
        return false if value.blank?
        # value_is_included?(record, attribute, value, valid_options)

        # if value < other_date
        #   record.errors.add(attribute, (options[:message] || "must be after #{options[:with].to_s.humanize}"))
        # end
        return true if value.to_date <= Date.today

        record.errors[attribute] << error_message(:past_date)

        false
      end
    end
  end
end
