# frozen_string_literal: true

require "spec_helper"

module Test
  LocationValidatable = Struct.new(:location) do
    include ActiveModel::Validations

    validates :location, "defra_ruby/validators/location": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe LocationValidator, type: :model do

      valid_location = %w[england northern_ireland scotland wales].sample
      invalid_location = "france"

      it_behaves_like("a validator")
      it_behaves_like(
        "a selection validator",
        LocationValidator,
        Test::LocationValidatable,
        :location,
        valid: valid_location, invalid: invalid_location
      )
    end
  end
end
