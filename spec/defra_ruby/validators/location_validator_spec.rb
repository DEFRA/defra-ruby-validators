# frozen_string_literal: true

require "spec_helper"

module Test
  LocationValidatable = Struct.new(:location) do
    include ActiveModel::Validations

    validates :location, "defra_ruby/validators/location": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe LocationValidator, type: :model do

      valid_location = %w[england northern_ireland scotland wales].sample
      invalid_location = "france"

      it_behaves_like("a validator")
      it_behaves_like(
        "a selection validator",
        described_class,
        Test::LocationValidatable,
        :location,
        valid: valid_location, invalid: invalid_location
      )

      context "when the value is overseas" do
        validatable = Test::LocationValidatable.new("overseas")

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
                          attribute: :location,
                          error: :inclusion,
                          error_message: error_message
        end
      end
    end
  end
end
