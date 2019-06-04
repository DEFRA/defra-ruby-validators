# frozen_string_literal: true

require "spec_helper"

module Test
  TrueFalseValidatable = Struct.new(:response) do
    include ActiveModel::Validations

    validates :response, "defra_ruby/validators/true_false": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe TrueFalseValidator do

      valid_value = %w[true false].sample

      it_behaves_like "a validator"
      it_behaves_like "a selection validator", TrueFalseValidator, Test::TrueFalseValidatable, :response, valid_value
    end
  end
end
