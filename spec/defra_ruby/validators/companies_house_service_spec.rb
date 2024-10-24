# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe DefraRuby::Validators::CompaniesHouseService do
  let(:host) { "https://api.companieshouse.gov.uk/" }

  describe "#status" do
    subject(:companies_house_service) { described_class.new(company_number:) }

    let(:company_number) { "09360070" }

    context "when the company_number is for an active company" do
      before do
        expected_body = { company_status: "active", type: "ltd" }

        stub_request(:any, /.*#{host}.*/).to_return(
          status: 200,
          body: expected_body.to_json
        )
      end

      context "with an eight-digit company_number" do
        let(:company_number) { "19360070" }

        it "returns :active" do
          expect(companies_house_service.status).to eq(:active)
        end
      end

      context "with a seven-digit company_number with a leading zero" do
        let(:company_number) { "09360070" }

        it "returns :active" do
          expect(companies_house_service.status).to eq(:active)
        end
      end

      context "with a seven-digit company_number without a leading zero" do
        let(:company_number) { "9360070" }

        it "returns :active" do
          expect(companies_house_service.status).to eq(:active)
        end
      end
    end

    context "when the company_number is not found" do
      before do
        stub_request(:any, /.*#{host}.*/).to_return(
          status: 404
        )
      end

      it "returns :not_found" do
        expect(companies_house_service.status).to eq(:not_found)
      end
    end

    context "when the company_number is inactive" do
      before do
        expected_body = { company_status: "dissolved", type: "ltd" }

        stub_request(:any, /.*#{host}.*/).to_return(
          status: 200,
          body: expected_body.to_json
        )
      end

      it "returns :inactive" do
        expect(companies_house_service.status).to eq(:inactive)
      end
    end

    context "when checking the company_type" do
      subject(:companies_house_service) { described_class.new(company_number: "09360070", permitted_types:) }

      let(:expected_body) { { company_status: "active", type: actual_type } }

      before do
        stub_request(:any, /.*#{host}.*/).to_return(
          status: 200,
          body: expected_body.to_json
        )
      end

      context "when an invalid permitted company types value is specified" do
        let(:permitted_types) { 0 }
        let(:actual_type) { nil }

        it { expect { companies_house_service.status }.to raise_error(ArgumentError) }
      end

      context "when no permitted company types are specified" do
        let(:permitted_types) { nil }
        let(:actual_type) { nil }

        it { expect(companies_house_service.status).to eq(:active) }
      end

      context "when a single permitted company type is specified" do
        let(:permitted_types) { "ltd" }

        context "when the actual type is llp" do
          let(:actual_type) { "llp" }

          it { expect(companies_house_service.status).to eq(:unsupported_company_type) }
        end

        context "when the actual type is ltd" do
          let(:actual_type) { "ltd" }

          it { expect(companies_house_service.status).to eq(:active) }
        end
      end

      context "when multiple permitted company types are specified" do
        let(:permitted_types) { %w[ltd llp] }

        context "when the actual type is llp" do
          let(:actual_type) { "llp" }

          it { expect(companies_house_service.status).to eq(:active) }
        end

        context "when the actual type is ltd" do
          let(:actual_type) { "ltd" }

          it { expect(companies_house_service.status).to eq(:active) }
        end
      end
    end

    context "when there is a problem with the Companies House API" do
      context "when the request times out" do
        before { stub_request(:any, /.*#{host}.*/).to_timeout }

        it "raises an exception" do
          expect { companies_house_service.status }.to raise_error(StandardError)
        end
      end

      context "when the request returns an error" do
        before { stub_request(:any, /.*#{host}.*/).to_raise(SocketError) }

        it "raises an exception" do
          expect { companies_house_service.status }.to raise_error(StandardError)
        end
      end
    end
  end
end
