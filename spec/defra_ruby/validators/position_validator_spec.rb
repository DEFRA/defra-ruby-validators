# frozen_string_literal: true

require "spec_helper"

module Test
  PositionValidatable = Struct.new(:position) do
    include ActiveModel::Validations

    validates :position, "defra_ruby/validators/position": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe PositionValidator, type: :model do

      valid_position = "Padawan"
      too_long_position = Helpers::TextGenerator.random_string(PositionValidator::MAX_LENGTH + 1)
      invalid_position = "**Invalid_@_Position**"
      empty_position = ""

      it_behaves_like("a validator")
      it_behaves_like(
        "a length validator",
        described_class,
        Test::PositionValidatable,
        :position,
        valid: valid_position, invalid: too_long_position
      )
      it_behaves_like(
        "a characters validator",
        described_class,
        Test::PositionValidatable,
        :position,
        valid: valid_position, invalid: invalid_position
      )

      describe "#validate_each" do
        context "when the position is valid" do
          context "when despite being blank (because position is optional)" do
            it_behaves_like "a valid record", Test::PositionValidatable.new(empty_position)
          end
        end
      end
    end
  end
end
