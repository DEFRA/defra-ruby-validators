# frozen_string_literal: true

require "spec_helper"

module Test
  TokenValidatable = Struct.new(:token) do
    include ActiveModel::Validations

    validates :token, "defra_ruby/validators/token": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe TokenValidator, type: :model do

      valid_token = Helpers::TextGenerator.random_string(24)
      invalid_token = "123456"

      it_behaves_like("a validator")
      it_behaves_like(
        "a presence validator",
        described_class,
        Test::TokenValidatable,
        :token,
        valid: valid_token
      )

      describe "#validate_each" do
        context "when the token is not valid" do
          context "when the token is not correctly formatted" do
            validatable = Test::TokenValidatable.new(invalid_token)
            error_message = Helpers::Translator.error_message(described_class, :invalid_format)

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :token,
                            error: :invalid_format,
                            error_message: error_message
          end
        end
      end
    end
  end
end
