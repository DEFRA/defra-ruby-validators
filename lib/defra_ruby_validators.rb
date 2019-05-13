# frozen_string_literal: true

require "defra_ruby/validators/engine"

# This breaks from the typical pattern of calling the root file in lib after the
# root namespace e.g. defra_ruby.rb
# The specific intent for this gem (engine) is to be used in our services rails
# engines i.e. an engine mounted in an engine.
#
# The standard pattern is to have an engine.rb in the relevant namespace. Hence
# in this project we have lib/defra_ruby/validators/engine.rb. When it comes to
# requiring this project in host engine this means it needs to require that
# file explicitly. For example in lib/waste_exemptions_engine/engine.rb the
# reference would be
#
# require "defra_ruby/validators/engine"
#
# That's fine, but it does mean this file becomes meaningless. Its not
# referenced by our specs as they refer to lib/defra_ruby/validators/validators.rb
# It's not referenced by engine.rb because it also references validators.rb.
#
# However if we call it defra_ruby_validators.rb and include a require to the
# engine, then the host engine can instead just do the following
#
# require "defra_ruby_validators"
#
# This makes the require statement consistent with the name of the gem, makes
# implementation a little simpler, and if we build up a suite of these engines
# makes them a little clearer to distinguish in the host engine's engine.rb.
module DefraRubyValidators
  # The Defra Ruby packages namespace
end
