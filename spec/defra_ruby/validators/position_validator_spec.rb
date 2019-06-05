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

      empty_position = ""
      too_long_position = Helpers::TextGenerator.random_string(71) # The max length is 70.
      invalid_position = "**Invalid_@_Position**"

      it_behaves_like "a validator"
      it_behaves_like "a length validator", PositionValidator, Test::PositionValidatable, :position, too_long_position
      it_behaves_like "a characters validator", PositionValidator, Test::PositionValidatable, :position, invalid_position

      describe "#validate_each" do
        context "when the position is valid" do
          context "despite being blank (because position is optional)" do
            it_behaves_like "a valid record", Test::PositionValidatable.new(empty_position)
          end
        end
      end
    end
  end
end
