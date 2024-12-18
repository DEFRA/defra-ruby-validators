# frozen_string_literal: true

require "spec_helper"

RSpec.describe DefraRuby::Validators do
  describe "VERSION" do
    it "is a string" do
      expect(DefraRuby::Validators::VERSION).to be_a(String)
    end

    it "is in the correct format" do
      expect(DefraRuby::Validators::VERSION).to match(/\d+\.\d+\.\d+/)
    end
  end
end
