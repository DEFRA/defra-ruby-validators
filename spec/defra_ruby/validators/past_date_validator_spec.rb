# frozen_string_literal: true

require "spec_helper"

module Test
  PastDateValidatable = Struct.new(:date) do
    include ActiveModel::Validations

    validates :date, "defra_ruby/validators/past_date": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe PastDateValidator, type: :model do

      valid_date = Date.today
      invalid_date = Date.today + 1

      it_behaves_like "a valid record", Test::PastDateValidatable.new(valid_date)
      it_behaves_like "an invalid record",
                      validatable: Test::PastDateValidatable.new(invalid_date),
                      attribute: :date,
                      error: :past_date,
                      error_message: Helpers::Translator.error_message(PastDateValidator, :past_date)
    end
  end
end
