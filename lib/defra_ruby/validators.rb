# frozen_string_literal: true

require "active_model"

require_relative "validators/version"
require_relative "validators/configuration"
require_relative "validators/companies_house_service"

require_relative "validators/concerns/can_validate_selection"

require_relative "validators/base_validator"
require_relative "validators/companies_house_number_validator"
require_relative "validators/true_false_validator"

module DefraRuby
  module Validators
  end
end
