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

      valid_value = %w[true false].sample

      it_behaves_like "a validator"
      it_behaves_like "a selection validator", TrueFalseValidator, Test::TrueFalseValidatable, :attribute, valid_value
    end
  end
end
