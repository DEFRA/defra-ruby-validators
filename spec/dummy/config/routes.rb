Rails.application.routes.draw do
  mount DefraRuby::Validators::Engine => "/defra_ruby_validators"
end
