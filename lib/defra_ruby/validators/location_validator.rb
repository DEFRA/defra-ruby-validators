# frozen_string_literal: true

module DefraRuby
  module Validators
    class LocationValidator < BaseValidator
      include CanValidateSelection

      def validate_each(record, _attribute, value)
        value_is_included?(record, :location, value, valid_options)
      end

      private

      def valid_options
        options = %w[england northern_ireland scotland wales]
        options.push("overseas") if allow_overseas?

        options
      end

      def allow_overseas?
        options[:allow_overseas] == true
      end
    end
  end
end
