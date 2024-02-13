# frozen_string_literal: true

require "defra_ruby/validators"

module DefraRuby
  module Validators
    # Engine used to load in the custom validations
    class Engine < ::Rails::Engine
      isolate_namespace DefraRuby::Validators

      # Add a load path for this specific Engine
      config.autoload_paths += Dir[File.join(config.root, "lib", "**")]

      # Load I18n translation files from engine before loading ones from the host app
      # This means values in the host app can override those in the engine
      config.before_initialize do
        Rails.logger.warn "\n>>>>>>>>> gem load_path was: #{config.i18n.load_path}\n"
        engine_locales = Dir["#{config.root}/config/locales/**/*.yml"]
        Rails.logger.warn "\n>>>>>>>>> gem engine adding: #{engine_locales}\n"
        config.i18n.load_path = engine_locales + config.i18n.load_path
        Rails.logger.warn "\n>>>>>>>>> gem load_path now: #{config.i18n.load_path}\n"
      end
    end
  end
end
