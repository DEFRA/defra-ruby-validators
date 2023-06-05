# frozen_string_literal: true

require "spec_helper"

RSpec.describe DefraRuby::Validators::Configuration do
  describe "ATTRIBUTES" do
    it "represents the expected config settings and only those settings" do
      expected_attributes = %i[
        companies_house_host
        companies_house_api_key
      ]

      expect(described_class::ATTRIBUTES).to match_array(expected_attributes)
    end
  end

  it "sets the appropriate default config settings" do
    fresh_config = described_class.new

    expect(fresh_config.companies_house_host).to eq("https://api.companieshouse.gov.uk/company/")
    expect(fresh_config.companies_house_api_key).to be_nil
  end

  describe "#ensure_valid" do
    before do
      described_class::ATTRIBUTES.each do |attribute|
        subject.public_send("#{attribute}=", "foo")
      end
    end

    context "when all of the attributes are present" do
      it "does not raise an error" do
        expect { subject.ensure_valid }.not_to raise_error
        expect(subject.ensure_valid).to be(true)
      end
    end

    context "when at least one of the attributes is missing" do
      before do
        subject.companies_house_api_key = nil
      end

      it "raises an error" do
        message = "The following DefraRuby::Validators configuration attributes are missing: [:companies_house_api_key]"
        expect { subject.ensure_valid }.to raise_error(message)
      end
    end
  end
end
