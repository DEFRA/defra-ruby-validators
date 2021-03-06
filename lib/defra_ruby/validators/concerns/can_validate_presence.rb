# frozen_string_literal: true

module DefraRuby
  module Validators
    module CanValidatePresence

      private

      def value_is_present?(record, attribute, value)
        return true if value.present?

        add_validation_error(record, attribute, :blank)
        false
      end

    end
  end
end
