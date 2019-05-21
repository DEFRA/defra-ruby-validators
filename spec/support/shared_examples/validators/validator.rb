# frozen_string_literal: true

RSpec.shared_examples "a validator" do
  it "is a type of BaseValidator" do
    expect(described_class.ancestors)
      .to include(DefraRuby::Validators::BaseValidator)
  end
end
