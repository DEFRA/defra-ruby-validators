# frozen_string_literal: true

RSpec.shared_examples "a characters validator" do |validator, validatable_class, property, invalid_input|
  it "includes CanValidateCharacters" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

    expect(included_modules)
      .to include(DefraRuby::Validators::CanValidateCharacters)
  end

  describe "#validate_each" do
    context "when the #{property} is not valid" do
      context "because the #{property} is not correctly formatted" do
        validatable = validatable_class.new(invalid_input)
        error_message = Helpers::Translator.error_message(klass: validator, error: :invalid)

        it_behaves_like "an invalid record", validatable, property, error_message
      end
    end
  end
end
