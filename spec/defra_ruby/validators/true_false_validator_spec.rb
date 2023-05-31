# frozen_string_literal: true

require "spec_helper"

module Test
  TrueFalseValidatable = Struct.new(:attribute) do
    include ActiveModel::Validations

    validates :attribute, "defra_ruby/validators/true_false": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe TrueFalseValidator do
      invalid_value = "unsure"

      it_behaves_like("a validator")

      it_behaves_like(
        "a selection validator",
        described_class,
        Test::TrueFalseValidatable,
        :attribute,
        valid: true, invalid: invalid_value
      )

      it_behaves_like(
        "a selection validator",
        described_class,
        Test::TrueFalseValidatable,
        :attribute,
        valid: false, invalid: invalid_value
      )
    end
  end
end
