# frozen_string_literal: true

require "spec_helper"

module Test
  PriceValidatable = Struct.new(:price) do
    include ActiveModel::Validations

    validates :price, "defra_ruby/validators/price": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe PriceValidator, type: :model do

      valid_price = "323.44"
      valid_price_float = 1684.23
      valid_price_integer = 743
      invalid_price = "f22.53535"

      it_behaves_like("a validator")
      it_behaves_like(
        "a presence validator",
        described_class,
        Test::PriceValidatable,
        :price,
        valid: valid_price
      )

      describe "#validate_each" do
        context "when the price is not valid" do
          context "when the price is not correctly formatted" do
            validatable = Test::PriceValidatable.new(invalid_price)

            error_message = Helpers::Translator.error_message(described_class, :invalid_format)

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :price,
                            error: :invalid_format,
                            error_message: error_message
          end
        end

        context "when the price is valid" do
          context "when the price is a string" do
            validatable = Test::PriceValidatable.new(valid_price)

            it_behaves_like "a valid record", validatable
          end

          context "when the price is a float" do
            validatable = Test::PriceValidatable.new(valid_price_float)

            it_behaves_like "a valid record", validatable
          end

          context "when the price is an integer" do
            validatable = Test::PriceValidatable.new(valid_price_integer)

            it_behaves_like "a valid record", validatable
          end
        end
      end
    end
  end
end
