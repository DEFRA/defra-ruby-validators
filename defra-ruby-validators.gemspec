# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem"s version:
require "defra_ruby_validators/version"

Gem::Specification.new do |spec|
  spec.name          = "defra_ruby_validators"
  spec.version       = DefraRubyValidators::VERSION
  spec.authors       = ["Defra"]
  spec.email         = ["alan.cruikshanks@environment-agency.gov.uk"]
  spec.license       = "The Open Government Licence (OGL) Version 3"
  spec.homepage      = "https://github.com/DEFRA/defra-ruby-validators"
  spec.summary       = "Defra ruby on rails validations"
  spec.description   = "Package of validations commonly used in Defra Rails based digital services"

  spec.files = Dir["{bin,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  spec.test_files = Dir["spec/**/*"]

  spec.require_paths = ["lib"]

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Include ActiveModel so that we have access to ActiveModel::Validations
  # ActiveModel::Validation is the central class within gem!
  spec.add_dependency "activemodel"
  # Use rest-client for external requests, eg. to Companies House
  spec.add_dependency "rest-client", "~> 2.0"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "defra_ruby_style"
  # Shim to load environment variables from a .env file into ENV
  spec.add_development_dependency "dotenv"
  # Allows us to automatically generate the change log from the tags, issues,
  # labels and pull requests on GitHub. Added as a dependency so all dev's have
  # access to it to generate a log, and so they are using the same version.
  # New dev's should first create GitHub personal app token and add it to their
  # ~/.bash_profile (or equivalent)
  # https://github.com/skywinder/github-changelog-generator#github-token
  spec.add_development_dependency "github_changelog_generator"
  # Allows us to check in our tests that the right message is being picked up
  spec.add_development_dependency "i18n"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "vcr", "~> 4.0"
  spec.add_development_dependency "webmock", "~> 3.4"
end
