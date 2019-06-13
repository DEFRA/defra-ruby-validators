# frozen_string_literal: true

module Helpers
  module Translator
    def self.error_message(klass, attribute, error)
      class_name = klass_name(klass)

      I18n.t("defra_ruby.validators.#{class_name}.#{attribute}.#{error}")
    end

    def self.klass_name(klass)
      klass.name.split("::").last
    end
  end
end
