# frozen_string_literal: true

module DefraRuby
  module Validators
    module CanValidateSelection

      private

      def value_is_included?(record, attribute, value, valid_options)
        # In this case, we do want `false.present?` to return `true` https://github.com/rails/rails/issues/10804
        return true if (value == false || value.present?) && valid_options.include?(value)

        record.errors[attribute] << error_message(:inclusion)
        false
      end

    end
  end
end
