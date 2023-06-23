# frozen_string_literal: true

require "spec_helper"

module Test
  MobilePhoneNumberValidatable = Struct.new(:mobile_phone_number) do
    include ActiveModel::Validations

    validates :mobile_phone_number, "defra_ruby/validators/mobile_phone_number": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe MobilePhoneNumberValidator, type: :model do

      valid_number = [
        "+447851567890",
        "07851567890",
        "+447851-567-890",
        "07851.567.890",
        "+447851 567 890"
      ].sample
      too_long_number = Helpers::TextGenerator.random_number_string(16) # The max length is 15.
      invalid_number = "#123"
      landline_number = "01234567890"

      it_behaves_like("a validator")
      it_behaves_like(
        "a presence validator",
        described_class,
        Test::MobilePhoneNumberValidatable,
        :mobile_phone_number,
        valid: valid_number
      )
      it_behaves_like(
        "a length validator",
        described_class,
        Test::MobilePhoneNumberValidatable,
        :mobile_phone_number,
        valid: valid_number, invalid: too_long_number
      )

      describe "#validate_each" do
        context "when the mobile phone number is not valid" do
          context "when the mobile phone number is not correctly formatted" do
            validatable = Test::MobilePhoneNumberValidatable.new(invalid_number)
            error_message = Helpers::Translator.error_message(described_class, :invalid_format)

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :mobile_phone_number,
                            error: :invalid_format,
                            error_message: error_message
          end

          context "when the phone number is landline phone number" do
            validatable = Test::MobilePhoneNumberValidatable.new(landline_number)
            error_message = Helpers::Translator.error_message(described_class, :invalid_format)

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :mobile_phone_number,
                            error: :invalid_format,
                            error_message: error_message
          end
        end
      end
    end
  end
end
