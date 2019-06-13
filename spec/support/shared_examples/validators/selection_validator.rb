# frozen_string_literal: true

RSpec.shared_examples "a selection validator" do |validator, validatable_class, attribute, valid_value|
  it "includes CanValidateSelection" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

    expect(included_modules)
      .to include(DefraRuby::Validators::CanValidateSelection)
  end

  describe "#validate_each" do
    context "when the #{attribute} is valid" do
      it_behaves_like "a valid record", validatable_class.new(valid_value)
    end

    context "when the #{attribute} is not valid" do
      context "because the #{attribute} is not present" do
        validatable = validatable_class.new
        error_message = Helpers::Translator.error_message(validator, attribute, :inclusion)

        it_behaves_like "an invalid record", validatable, attribute, error_message
      end

      context "because the #{attribute} is not from an approved list" do
        validatable = validatable_class.new("unexpected_#{attribute}")
        error_message = Helpers::Translator.error_message(validator, attribute, :inclusion)

        it_behaves_like "an invalid record", validatable, attribute, error_message
      end
    end
  end
end
