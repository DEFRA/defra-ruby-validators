# frozen_string_literal: true

module DefraRuby
  module Validators
    class LocationValidator < BaseValidator
      include CanValidateSelection

      def validate_each(record, _attribute, value)
        valid_options = %w[england northern_ireland scotland wales]

        value_is_included?(record, :location, value, valid_options)
      end
    end
  end
end
