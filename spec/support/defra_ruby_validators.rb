# frozen_string_literal: true

DefraRuby::Validators.configure do |c|
  def raise_missing_env_var(variable)
    raise("Environment variable #{variable} has not been set")
  end

  c.companies_house_api_key = (ENV["COMPANIES_HOUSE_API_KEY"] || raise_missing_env_var("COMPANIES_HOUSE_API_KEY"))
end
