# frozen_string_literal: true

require "spec_helper"

module Test
  BusinessTypeValidatable = Struct.new(:business_type) do
    include ActiveModel::Validations

    validates :business_type, "defra_ruby/validators/business_type": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe BusinessTypeValidator do

      valid_type = %w[soleTrader limitedCompany partnership limitedLiabilityPartnership localAuthority charity].sample
      invalid_type = "coven"

      it_behaves_like("a validator")
      it_behaves_like(
        "a selection validator",
        BusinessTypeValidator,
        Test::BusinessTypeValidatable,
        :business_type,
        valid: valid_type, invalid: invalid_type
      )
    end
  end
end
