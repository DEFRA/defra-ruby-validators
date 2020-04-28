# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe DefraRuby::Validators::CompaniesHouseService do
  let(:subject) { described_class.new("09360070") }
  let(:host) { "https://api.companieshouse.gov.uk/" }

  describe "#status" do
    context "when the company_no is for an active company" do
      before do
        expected_body = { "company_status": "active" }

        stub_request(:any, /.*#{host}.*/).to_return(
          status: 200,
          body: expected_body.to_json
        )
      end

      it "returns :active" do
        expect(subject.status).to eq(:active)
      end
    end

    context "when the company_no is not found" do
      before do
        stub_request(:any, /.*#{host}.*/).to_return(
          status: 404
        )
      end

      it "returns :not_found" do
        expect(subject.status).to eq(:not_found)
      end
    end

    context "when the company_no is inactive" do
      before do
        expected_body = { "company_status": "dissolved" }

        stub_request(:any, /.*#{host}.*/).to_return(
          status: 200,
          body: expected_body.to_json
        )
      end

      it "returns :inactive" do
        expect(subject.status).to eq(:inactive)
      end
    end

    context "when there is a problem with the Companies House API" do
      context "and the request times out" do
        before { stub_request(:any, /.*#{host}.*/).to_timeout }

        it "raises an exception" do
          expect { subject.status }.to raise_error(StandardError)
        end
      end

      context "and request returns an error" do
        before { stub_request(:any, /.*#{host}.*/).to_raise(SocketError) }

        it "raises an exception" do
          expect { subject.status }.to raise_error(StandardError)
        end
      end
    end
  end
end
