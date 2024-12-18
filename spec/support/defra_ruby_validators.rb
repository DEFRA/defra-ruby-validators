# frozen_string_literal: true

# Need to require our actual code files. We don't just require everything in
# lib/defra_ruby because it contains the engine file which has a dependency on
# rails. We don't have that as a dependency of this project because it is
# a given this will be used in a rails project. So instead we require the
# validators file directly to load the content covered by our tests.
require "defra_ruby/validators"

DefraRuby::Validators.configure do |_c|
  def raise_missing_env_var(variable)
    raise("Environment variable #{variable} has not been set")
  end
end
