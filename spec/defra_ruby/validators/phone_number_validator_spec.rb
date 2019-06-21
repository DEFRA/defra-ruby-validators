# frozen_string_literal: true

require "spec_helper"

module Test
  PhoneNumberValidatable = Struct.new(:phone_number) do
    include ActiveModel::Validations

    validates :phone_number, "defra_ruby/validators/phone_number": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe PhoneNumberValidator, type: :model do

      valid_number = [
        "+441234567890",
        "01234567890",
        "+441234-567-890",
        "01234.567.890",
        "+441234 567 890"
      ].sample
      too_long_number = Helpers::TextGenerator.random_number_string(16) # The max length is 15.
      invalid_number = "#123"

      it_behaves_like("a validator")
      it_behaves_like(
        "a presence validator",
        PhoneNumberValidator,
        Test::PhoneNumberValidatable,
        :phone_number,
        valid: valid_number
      )
      it_behaves_like(
        "a length validator",
        PhoneNumberValidator,
        Test::PhoneNumberValidatable,
        :phone_number,
        valid: valid_number, invalid: too_long_number
      )

      describe "#validate_each" do
        context "when the phone number is not valid" do
          context "because the phone number is not correctly formatted" do
            validatable = Test::PhoneNumberValidatable.new(invalid_number)
            error_message = Helpers::Translator.error_message(PhoneNumberValidator, :phone_number, :invalid_format)

            it_behaves_like "an invalid record", validatable, :phone_number, error_message
          end
        end
      end
    end
  end
end
