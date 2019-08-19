# frozen_string_literal: true

require "spec_helper"

module Test
  CompaniesHouseNumberValidatable = Struct.new(:company_no) do
    include ActiveModel::Validations

    validates :company_no, "defra_ruby/validators/companies_house_number": true
  end
end

module DefraRuby
  module Validators
    RSpec.describe CompaniesHouseNumberValidator do

      valid_numbers = %w[10997904 09764739 SC534714 IP00141R]
      invalid_format_number = "foobar42"
      unknown_number = "99999999"
      inactive_number = "07281919"

      it_behaves_like "a validator"

      describe "#validate_each" do
        context "when given a valid company number" do
          before do
            allow_any_instance_of(CompaniesHouseService).to receive(:status).and_return(:active)
          end

          valid_numbers.each do |company_no|
            context "like #{company_no}" do
              it_behaves_like "a valid record", Test::CompaniesHouseNumberValidatable.new(company_no)
            end
          end
        end

        context "when given an invalid company number" do
          context "because it is blank" do
            validatable = Test::CompaniesHouseNumberValidatable.new
            error_message = Helpers::Translator.error_message(
              CompaniesHouseNumberValidator,
              :company_no,
              :blank
            )

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :company_no,
                            error: :blank,
                            error_message: error_message
          end

          context "because the format is wrong" do
            validatable = Test::CompaniesHouseNumberValidatable.new(invalid_format_number)
            error_message = Helpers::Translator.error_message(
              CompaniesHouseNumberValidator,
              :company_no,
              :invalid_format
            )

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :company_no,
                            error: :invalid_format,
                            error_message: error_message
          end

          context "because it's not found on companies house" do
            before do
              allow_any_instance_of(CompaniesHouseService).to receive(:status).and_return(:not_found)
            end

            validatable = Test::CompaniesHouseNumberValidatable.new(unknown_number)
            error_message = Helpers::Translator.error_message(
              CompaniesHouseNumberValidator,
              :company_no,
              :not_found
            )

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :company_no,
                            error: :not_found,
                            error_message: error_message
          end

          context "because it's not 'active' on companies house" do
            before do
              allow_any_instance_of(CompaniesHouseService).to receive(:status).and_return(:inactive)
            end

            validatable = Test::CompaniesHouseNumberValidatable.new(inactive_number)
            error_message = Helpers::Translator.error_message(
              CompaniesHouseNumberValidator,
              :company_no,
              :inactive
            )

            it_behaves_like "an invalid record",
                            validatable: validatable,
                            attribute: :company_no,
                            error: :inactive,
                            error_message: error_message
          end
        end

        context "when there is an error connecting with companies house" do
          before do
            allow_any_instance_of(CompaniesHouseService).to receive(:status).and_raise(StandardError)
          end

          validatable = Test::CompaniesHouseNumberValidatable.new(valid_numbers.sample)
          error_message = Helpers::Translator.error_message(
            CompaniesHouseNumberValidator,
            :company_no,
            :error
          )

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
