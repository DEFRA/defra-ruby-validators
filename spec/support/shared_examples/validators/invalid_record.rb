# frozen_string_literal: true

RSpec.shared_examples "an invalid record" do |validatable, attribute, error_message|
  it "confirms the object is invalid" do
    expect(validatable).to_not be_valid
  end

  it "adds a single validation error to the record" do
    validatable.valid?
    expect(validatable.errors[attribute].count).to eq(1)
  end

  it "adds an appropriate validation error" do
    validatable.valid?
    expect(error_message).to_not include("translation missing:")
    expect(validatable.errors[attribute]).to eq([error_message])
  end

  context "when there is a custom error message" do
    let(:custom_message) { "something is wrong (in a customised way)" }
    before { allow_any_instance_of(DefraRuby::Validators::BaseValidator).to receive(:options).and_return(message: custom_message) }

    it "uses the custom message instead of the default" do
      validatable.valid?
      expect(validatable.errors[attribute]).to eq([custom_message])
    end
  end
end
