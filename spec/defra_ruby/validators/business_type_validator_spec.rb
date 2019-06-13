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

      valid_value = %w[soleTrader limitedCompany partnership limitedLiabilityPartnership localAuthority charity].sample

      it_behaves_like "a validator"
      it_behaves_like(
        "a selection validator",
        BusinessTypeValidator,
        Test::BusinessTypeValidatable,
        :business_type,
        valid_value
      )
    end
  end
end
