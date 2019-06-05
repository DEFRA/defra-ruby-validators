# frozen_string_literal: true

RSpec.shared_examples "a presence validator" do |validator, validatable_class, property|
  it "includes CanValidatePresence" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

    expect(included_modules)
      .to include(DefraRuby::Validators::CanValidatePresence)
  end

  describe "#validate_each" do
    context "when the #{property} is not valid" do
      context "because the #{property} is not present" do
        validatable = validatable_class.new
        error_message = Helpers::Translator.error_message(klass: validator, error: :blank)

        it_behaves_like "an invalid record", validatable, property, error_message
      end
    end
  end
end
