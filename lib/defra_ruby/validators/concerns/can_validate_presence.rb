# frozen_string_literal: true

module DefraRuby
  module Validators
    module CanValidatePresence
      extend ActiveSupport::Concern

      included do
        private

        def value_is_present?(record, attribute, value)
          return true if value.present?

          record.errors[attribute] << error_message(error: "blank")
          false
        end
      end
    end
  end
end
