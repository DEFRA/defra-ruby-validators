# frozen_string_literal: true

module DefraRubyValidators
  RSpec.describe CompaniesHouseNumberValidator do
    context "when given a valid company number" do
      before do
        allow_any_instance_of(CompaniesHouseService).to receive(:status).and_return(:active)
      end

      %w[10997904 09764739 SC534714 IP00141R].each do |company_no|
        context "like #{company_no}" do
          it "confirms the number is valid" do
            expect(DummyCompaniesHouseNumber.new(company_no)).to be_valid
          end
        end
      end
    end

    context "when given an invalid company number" do
      context "because it is blank" do
        subject { DummyCompaniesHouseNumber.new("") }

        it "confirms the number is not valid" do
          expect(subject).to_not be_valid
        end
        it "adds an error to the subject's errors collection" do
          subject.valid?
          expect(subject.errors.count).to eq(1)
        end
        it "adds an error with the correct message" do
          subject.valid?
          expect(subject.errors[:company_no][0]).to eq(I18n.t("defra_ruby_validators.companies_house_number.errors.blank"))
        end
      end

      context "because the format is wrong" do
        subject { DummyCompaniesHouseNumber.new("foobar42") }

        it "confirms the number is not valid" do
          expect(subject).to_not be_valid
        end
        it "adds an error to the subject's errors collection" do
          subject.valid?
          expect(subject.errors.count).to eq(1)
        end
        it "adds an error with the correct message" do
          subject.valid?
          expect(subject.errors[:company_no][0]).to eq(I18n.t("defra_ruby_validators.companies_house_number.errors.invalid"))
        end
      end

      context "because it's not found on companies house" do
        before do
          allow_any_instance_of(CompaniesHouseService).to receive(:status).and_return(:not_found)
        end

        subject { DummyCompaniesHouseNumber.new("99999999") }

        it "confirms the number is not valid" do
          expect(subject).to_not be_valid
        end
        it "adds an error to the subject's errors collection" do
          subject.valid?
          expect(subject.errors.count).to eq(1)
        end
        it "adds an error with the correct message" do
          subject.valid?
          expect(subject.errors[:company_no][0]).to eq(I18n.t("defra_ruby_validators.companies_house_number.errors.not_found"))
        end
      end

      context "because it's not 'active' on companies house" do
        before do
          allow_any_instance_of(CompaniesHouseService).to receive(:status).and_return(:inactive)
        end

        subject { DummyCompaniesHouseNumber.new("07281919") }

        it "confirms the number is not valid" do
          expect(subject).to_not be_valid
        end
        it "adds an error to the subject's errors collection" do
          subject.valid?
          expect(subject.errors.count).to eq(1)
        end
        it "adds an error with the correct message" do
          subject.valid?
          expect(subject.errors[:company_no][0]).to eq(I18n.t("defra_ruby_validators.companies_house_number.errors.inactive"))
        end
      end
    end

    context "when there is an error connecting with companies house" do
      before do
        allow_any_instance_of(CompaniesHouseService).to receive(:status).and_raise(StandardError)
      end

      subject { DummyCompaniesHouseNumber.new("10997904") }

      it "confirms the number is not valid" do
        expect(subject).to_not be_valid
      end
      it "adds an error to the subject's errors collection" do
        subject.valid?
        expect(subject.errors.count).to eq(1)
      end
      it "adds an error with the correct message" do
        subject.valid?
        expect(subject.errors[:company_no][0]).to eq(I18n.t("defra_ruby_validators.companies_house_number.errors.error"))
      end
    end

    class DummyCompaniesHouseNumber
      include ActiveModel::Model

      attr_accessor :company_no

      def initialize(company_no)
        @company_no = company_no
      end

      validates :company_no, "defra_ruby_validators/companies_house_number": true
    end
  end
end
