# frozen_string_literal: true

require "spec_helper"

module Test
  EmailValidatable = Struct.new(:email) do
    include ActiveModel::Validations

    validates :email, "defra_ruby/validators/email": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe EmailValidator, type: :model do

      valid_email = "test@example.com"
      invalid_email = "foo@bar"

      it_behaves_like("a validator")
      it_behaves_like(
        "a presence validator",
        EmailValidator,
        Test::EmailValidatable,
        :email,
        valid: valid_email
      )

      describe "#validate_each" do
        context "when the email is not valid" do
          context "because the email is not correctly formatted" do
            validatable = Test::EmailValidatable.new(invalid_email)

            error_message = Helpers::Translator.error_message(EmailValidator, :email, :invalid_format)

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :email,
                            error: :invalid_format,
                            error_message: error_message
          end
        end
      end
    end
  end
end
