# frozen_string_literal: true

RSpec.describe DefraRuby::Validators::CompaniesHouseService do
  let(:subject) { described_class.new("09360070") }
  let(:host) { "https://api.companieshouse.gov.uk/" }

  describe "#status" do
    context "when the company_no is for an active company" do
      # before(:each) { VCR.insert_cassette("company_no_valid") }
      # after(:each) { VCR.eject_cassette }

      it "returns :active" do
        expect(subject.status).to eq(:active)
      end
    end

    context "when the company_no is not found" do
      let(:subject) { described_class.new("99999999") }
      # before(:each) { VCR.insert_cassette("company_no_not_found") }
      # after(:each) { VCR.eject_cassette }

      it "returns :not_found" do
        expect(subject.status).to eq(:not_found)
      end
    end

    context "when the company_no is inactive" do
      let(:subject) { described_class.new("07281919") }
      # before(:each) { VCR.insert_cassette("company_no_inactive") }
      # after(:each) { VCR.eject_cassette }

      it "returns :inactive" do
        expect(subject.status).to eq(:inactive)
      end
    end

    context "when there is a problem with the Companies House API" do
      context "and the request times out" do
        before(:each) { stub_request(:any, /.*#{host}.*/).to_timeout }

        it "raises an exception" do
          expect { subject.status }.to raise_error(StandardError)
        end
      end

      context "and request returns an error" do
        before(:each) { stub_request(:any, /.*#{host}.*/).to_raise(SocketError) }

        it "raises an exception" do
          expect { subject.status }.to raise_error(StandardError)
        end
      end
    end
  end
end
