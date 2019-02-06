# frozen_string_literal: true

module DefraRubyValidators
  RSpec.describe TrueFalseValidator do
    %w[true false].each do |value|
      context "when given the valid value '#{value}'" do
        it "confirms the value is valid" do
          expect(DummyTrueFalse.new(value)).to be_valid
        end
      end
    end

    context "when given an invalid value" do
      context "because it is blank" do
        subject { DummyTrueFalse.new("") }

        it "confirms the value is not valid" do
          expect(subject).to_not be_valid
        end
        it "adds an error to the subject's errors collection" do
          subject.valid?
          expect(subject.errors.count).to eq(1)
        end
        it "adds an error with the correct message" do
          subject.valid?
          expect(subject.errors[:value][0]).to eq(I18n.t("defra_ruby_validators.true_false.errors.blank"))
        end
      end
    end

    context "because the value is not recognised" do
      subject { DummyTrueFalse.new("foobar") }

      it "confirms the value is not valid" do
        expect(subject).to_not be_valid
      end
      it "adds an error to the subject's errors collection" do
        subject.valid?
        expect(subject.errors.count).to eq(1)
      end
      it "adds an error with the correct message" do
        subject.valid?
        expect(subject.errors[:value][0]).to eq(I18n.t("defra_ruby_validators.true_false.errors.invalid"))
      end
    end

    class DummyTrueFalse
      include ActiveModel::Model

      attr_accessor :value

      def initialize(value)
        @value = value
      end

      validates :value, "defra_ruby_validators/true_false": true
    end
  end
end
