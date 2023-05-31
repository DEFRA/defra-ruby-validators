# frozen_string_literal: true

require "spec_helper"

module Test
  CompaniesHouseNumberValidatable = Struct.new(:company_no) do
    include ActiveModel::Validations

    validates :company_no, "defra_ruby/validators/companies_house_number": true
  end

  CompaniesHouseCompanyTypeAndNumberValidatable = Struct.new(:company_no) do
    include ActiveModel::Validations

    validates :company_no, "defra_ruby/validators/companies_house_number": { company_type: "ltd" }
  end
end

module DefraRuby
  module Validators
    RSpec.describe CompaniesHouseNumberValidator do

      let(:companies_house_service) { instance_double(CompaniesHouseService) }

      before do
        allow(CompaniesHouseService).to receive(:new).and_return(companies_house_service)
        allow(companies_house_service).to receive(:status)
      end

      valid_numbers = %w[10997904 09764739 SC534714 IP00141R]
      invalid_format_number = "foobar42"
      unknown_number = "99999999"
      inactive_number = "07281919"

      it_behaves_like "a validator"

      describe "#validate_each" do
        context "when given a valid company number" do
          before { allow(companies_house_service).to receive(:status).and_return(:active) }

          valid_numbers.each do |company_no|
            context "with #{company_no}" do
              it_behaves_like "a valid record", Test::CompaniesHouseNumberValidatable.new(company_no)
            end
          end
        end

        context "when given an invalid company number" do
          context "when it is blank" do
            validatable = Test::CompaniesHouseNumberValidatable.new
            error_message = Helpers::Translator.error_message(described_class, :blank)

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :company_no,
                            error: :blank,
                            error_message: error_message
          end

          context "when the format is wrong" do
            validatable = Test::CompaniesHouseNumberValidatable.new(invalid_format_number)
            error_message = Helpers::Translator.error_message(described_class, :invalid_format)

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :company_no,
                            error: :invalid_format,
                            error_message: error_message
          end

          context "when it consists of all zeroes" do
            validatable = Test::CompaniesHouseNumberValidatable.new("00000000")
            error_message = Helpers::Translator.error_message(described_class, :invalid_format)

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :company_no,
                            error: :invalid_format,
                            error_message: error_message
          end

          context "when it's not found on companies house" do
            before { allow(companies_house_service).to receive(:status).and_return(:not_found) }

            validatable = Test::CompaniesHouseNumberValidatable.new(unknown_number)
            error_message = Helpers::Translator.error_message(described_class, :not_found)

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :company_no,
                            error: :not_found,
                            error_message: error_message
          end

          context "when it's not 'active' on companies house" do
            before { allow(companies_house_service).to receive(:status).and_return(:inactive) }

            validatable = Test::CompaniesHouseNumberValidatable.new(inactive_number)
            error_message = Helpers::Translator.error_message(described_class, :inactive)

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :company_no,
                            error: :inactive,
                            error_message: error_message
          end

          context "with a company_type option" do
            let(:company_no) { valid_numbers.first }

            it "calls the companies house service with the `ltd` param" do
              Test::CompaniesHouseCompanyTypeAndNumberValidatable.new(company_no).valid?

              expect(CompaniesHouseService).to have_received(:new).with(company_no, "ltd")
            end
          end
        end

        context "when there is an error connecting with companies house" do
          before { allow(companies_house_service).to receive(:status).and_raise(StandardError) }

          validatable = Test::CompaniesHouseNumberValidatable.new(valid_numbers.sample)
          error_message = Helpers::Translator.error_message(described_class, :error)

          it_behaves_like "an invalid record",
                          validatable: validatable,
                          attribute: :company_no,
                          error: :error,
                          error_message: error_message
        end
      end
    end
  end
end
