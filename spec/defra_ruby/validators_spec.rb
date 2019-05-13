# frozen_string_literal: true

require "spec_helper"

RSpec.describe DefraRuby::Validators do
  describe "VERSION" do
    it "is a version string in the correct format" do
      expect(DefraRuby::Validators::VERSION).to be_a(String)
      expect(DefraRuby::Validators::VERSION).to match(/\d+\.\d+\.\d+/)
    end
  end
end
