# frozen_string_literal: true

require "spec_helper"

module Test
  PostcodeValidatable = Struct.new(:postcode) do
    include ActiveModel::Validations

    validates :postcode, "defra_ruby/validators/postcode": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe PostcodeValidator, type: :model do

      valid_postcode = "BS1 5AH"

      it_behaves_like("a validator")
      it_behaves_like("a presence validator", described_class, Test::PostcodeValidatable, :postcode, valid: valid_postcode)

      describe "#validate_each" do

        RSpec.shared_examples "an invalid postcode" do |postcode_string:, error_message_key:|
          it_behaves_like "an invalid record",
                          validatable: Test::PostcodeValidatable.new(postcode_string),
                          attribute: :postcode,
                          error: error_message_key,
                          error_message: Helpers::Translator.error_message(described_class, error_message_key)
        end

        context "when the postcode string is blank" do
          it_behaves_like "an invalid postcode", postcode_string: "", error_message_key: :blank
        end

        context "when the postcode string is nothing like a valid postcode" do
          it_behaves_like "an invalid postcode", postcode_string: "foo", error_message_key: :invalid_format
        end

        context "when the postcode string has leading 0 instead of O in the outcode" do
          it_behaves_like "an invalid postcode", postcode_string: "0X129TF", error_message_key: :invalid_format
        end

        context "when the postcode string has trailing O instead of 0 in the outcode" do
          it_behaves_like "an invalid postcode", postcode_string: "SSO 9SL", error_message_key: :invalid_format
        end

        context "when the postcode string has leading O instead of 0 in the incode" do
          it_behaves_like "an invalid postcode", postcode_string: "SS0 OSL", error_message_key: :invalid_format
        end
      end
    end
  end
end
