# frozen_string_literal: true

RSpec.describe Automations do
  # standard:disable Lint/ConstantDefinitionInBlock
  class ATrigger < Data.define(:config)
    def call(params) = true
  end

  class AnAction < Data.define(:config)
    def call(params) = params
  end
  # standard:enable Lint/ConstantDefinitionInBlock

  it "builds an automation" do
    config = {
      name: "Simple automation",
      class_name: "ATrigger",
      configuration: {},
      actions: [
        {class_name: "AnAction", configuration: {}}
      ]
    }
    automation = Automations.create(config)
    expect(automation).to be_kind_of(Automations::Implementation)
  end

  it "has a version number" do
    expect(Automations::VERSION).not_to be nil
  end
end
