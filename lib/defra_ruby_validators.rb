# frozen_string_literal: true

require "defra_ruby_validators/engine"

module DefraRubyValidators
  # See lib/defra_ruby_validators/validators.rb for the main content.
  # We have this file which just require's engine.rb to support using the gem
  # in a rails project.
  # For our test suite, we just want the typical listing of `require "filex"`,
  # as the engine references using Rails.
  # We also have the gem setup to support being configured from the host app.
  # This is all done in `validators.rb`, which is picked up by `engine.rb` as
  # well.
end
