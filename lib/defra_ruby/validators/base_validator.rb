# frozen_string_literal: true

module DefraRuby
  module Validators
    class BaseValidator < ActiveModel::EachValidator

      protected

      def error_message(attribute: nil, error:)
        return I18n.t("defra_ruby.validators.#{class_name}.#{attribute}.#{error}") if attribute

        I18n.t("defra_ruby.validators.#{class_name}.#{error}")
      end

      private

      def class_name
        self.class.name.split("::").last
      end

    end
  end
end
