# frozen_string_literal: true

module DefraRuby
  module Validators
    class BaseValidator < ActiveModel::EachValidator

      protected

      def error_message(error)
        if options[:messages] && options[:messages][error]
          options[:messages][error]
        else
          I18n.t("defra_ruby.validators.#{class_name}.#{error}")
        end
      end

      private

      def class_name
        self.class.name.split("::").last
      end

    end
  end
end
