# frozen_string_literal: true

RSpec.shared_examples "a selection validator" do |validator, validatable_class, attribute, values|
  it "includes CanValidateSelection" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

    expect(included_modules)
      .to include(DefraRuby::Validators::CanValidateSelection)
  end

  describe "#validate_each" do
    context "when the #{attribute} is valid" do
      it_behaves_like "a valid record", validatable_class.new(values[:valid])
    end

    context "when the #{attribute} is not valid" do
      context "when the #{attribute} is not present" do
        validatable = validatable_class.new
        error_message = Helpers::Translator.error_message(validator, :inclusion)

        it_behaves_like "an invalid record",
                        validatable: validatable,
                        attribute: attribute,
                        error: :inclusion,
                        error_message: error_message
      end

      context "when the #{attribute} is not from an approved list" do
        validatable = validatable_class.new(values[:invalid])
        error_message = Helpers::Translator.error_message(validator, :inclusion)

        it_behaves_like "an invalid record",
                        validatable: validatable,
                        attribute: attribute,
                        error: :inclusion,
                        error_message: error_message
      end
    end
  end
end
