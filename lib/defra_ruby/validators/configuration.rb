# frozen_string_literal: true

module DefraRuby
  module Validators
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      # Removed companies house configuration but laving the class in place to avoid knock-on impacts on apps.
    end
  end
end
