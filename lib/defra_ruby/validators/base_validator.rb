# frozen_string_literal: true

module DefraRuby
  module Validators
    class BaseValidator < ActiveModel::EachValidator

      protected

      def error_message(attribute, error)
        if options[:messages] && options[:messages][error]
          options[:messages][error]
        else
          I18n.t("defra_ruby.validators.#{class_name}.#{attribute}.#{error}")
        end
      end

      private

      def class_name
        self.class.name.split("::").last
      end

    end
  end
end
