# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe DefraRuby::Validators::CompaniesHouseService do
  let(:host) { "https://api.companieshouse.gov.uk/" }

  describe "#status" do
    let(:subject) { described_class.new("09360070") }

    context "when the company_no is for an active company" do
      before do
        expected_body = { "company_status": "active", "type": "ltd" }

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
        expected_body = { "company_status": "dissolved", "type": "ltd" }

        stub_request(:any, /.*#{host}.*/).to_return(
          status: 200,
          body: expected_body.to_json
        )
      end

      it "returns :inactive" do
        expect(subject.status).to eq(:inactive)
      end
    end

    context "checking the company_type" do
      let(:subject) { described_class.new("09360070", "llp") }

      context "when the company_no is for a LLP" do
        before do
          stub_request(:any, /.*#{host}.*/).to_return(
            status: 200,
            body: expected_body.to_json
          )
        end

        let(:expected_body) { { "company_status": "active", "type": "llp" } }

        it "returns :active" do
          expect(subject.status).to eq(:active)
        end

        context "but a ltd company is found" do
          let(:expected_body) { { "company_status": "active", "type": "ltd" } }

          it "returns :not_found" do
            expect(subject.status).to eq(:not_found)
          end
        end
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
