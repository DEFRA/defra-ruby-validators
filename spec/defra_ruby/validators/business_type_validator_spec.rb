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
        described_class,
        Test::BusinessTypeValidatable,
        :business_type,
        valid: valid_type, invalid: invalid_type
      )

      context "when the value is overseas" do
        validatable = Test::BusinessTypeValidatable.new("overseas")

        context "when overseas_allowed is enabled" do
          before do
            allow_any_instance_of(DefraRuby::Validators::BaseValidator).to receive(:options).and_return(allow_overseas: true)
          end

          it_behaves_like "a valid record", validatable
        end

        context "when overseas_allowed is not enabled" do
          before do
            allow_any_instance_of(DefraRuby::Validators::BaseValidator).to receive(:options).and_return({})
          end

          error_message = Helpers::Translator.error_message(described_class, :inclusion)

          it_behaves_like "an invalid record",
                          validatable: validatable,
                          attribute: :business_type,
                          error: :inclusion,
                          error_message: error_message
        end
      end
    end
  end
end
