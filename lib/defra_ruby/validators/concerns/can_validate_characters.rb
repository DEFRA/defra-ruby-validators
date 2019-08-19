# frozen_string_literal: true

module DefraRuby
  module Validators
    module CanValidateCharacters

      private

      def value_has_no_invalid_characters?(record, attribute, value)
        # Name fields must contain only letters, spaces, commas, full stops, hyphens and apostrophes
        return true if value.match?(/\A[-a-z\s,.']+\z/i)

        record.errors[attribute] << error_message(attribute, :invalid_format)
        false
      end

    end
  end
end
