# frozen_string_literal: true

module DefraRuby
  module Validators
    class TrueFalseValidator < BaseValidator
      include CanValidateSelection

      def validate_each(record, attribute, value)
        valid_options = [true, false]

        value_is_included?(record, attribute, value, valid_options)
      end
    end
  end
end
