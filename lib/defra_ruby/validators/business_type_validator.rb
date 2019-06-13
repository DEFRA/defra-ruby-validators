# frozen_string_literal: true

module DefraRuby
  module Validators
    class BusinessTypeValidator < BaseValidator
      include CanValidateSelection

      def validate_each(record, _attribute, value)
        valid_options = %w[soleTrader limitedCompany partnership limitedLiabilityPartnership localAuthority charity]

        value_is_included?(record, :business_type, value, valid_options)
      end
    end
  end
end
