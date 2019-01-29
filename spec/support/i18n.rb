# frozen_string_literal: true

# Support using the locale files within our tests (else we'd rely on loading the
# gem in a rails app to confirm these are being pulled through correctly.)
require "i18n"

I18n.load_path << Dir[File.expand_path("config/locales") + "/**/*.yml"]
I18n.default_locale = :en
