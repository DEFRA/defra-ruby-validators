# frozen_string_literal: true

module DefraRuby
  module Validators
    class BusinessTypeValidator < BaseValidator
      include CanValidateSelection

      def validate_each(record, _attribute, value)
        value_is_included?(record, :business_type, value, valid_options)
      end

      private

      def valid_options
        options = %w[soleTrader limitedCompany partnership limitedLiabilityPartnership localAuthority charity]
        options.push("overseas") if allow_overseas?

        options
      end

      def allow_overseas?
        options[:allow_overseas] == true
      end
    end
  end
end
