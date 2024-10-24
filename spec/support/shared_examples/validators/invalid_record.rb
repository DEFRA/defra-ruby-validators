# frozen_string_literal: true

RSpec.shared_examples "an invalid record" do |validatable:, attribute:, error:, error_message:|
  it "confirms the object is invalid" do
    expect(validatable).not_to be_valid
  end

  it "adds a single validation error to the record" do
    validatable.valid?
    expect(validatable.errors[attribute].count).to eq(1)
  end

  it "adds an appropriate validation error" do
    validatable.valid?
    expect(error_message).not_to include("translation missing:")
    expect(validatable.errors[attribute]).to eq([error_message])
  end

  context "when there are custom error messages" do
    let(:custom_message) { "something is wrong (in a customised way)" }
    let(:messages) { { error => custom_message } }

    before do
      # Merge custom message with any pre-existing options
      original_options = validatable._validators[attribute].first.options
      # Make a modifiable copy as the original is frozen
      options = original_options.dup
      options[:messages] = messages

      allow_any_instance_of(DefraRuby::Validators::BaseValidator).to receive(:options).and_return(options)
    end

    it "uses the custom message instead of the default" do
      validatable.valid?
      expect(validatable.errors[attribute]).to eq([custom_message])
    end
  end
end
