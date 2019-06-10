# frozen_string_literal: true

module DefraRuby
  module Validators
    module CanValidateSelection

      private

      def value_is_included?(record, attribute, value, valid_options)
        return true if value.present? && valid_options.include?(value)

        record.errors[attribute] << error_message(error: "inclusion")
        false
      end

    end
  end
end
