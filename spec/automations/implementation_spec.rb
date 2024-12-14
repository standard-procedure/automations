require "spec_helper"

RSpec.describe Automations::Implementation do
  # standard:disable Lint/ConstantDefinitionInBlock
  class Automations::TriggerDoesNotFire < Data.define(:config)
    def call(params) = false
  end

  class Automations::TriggerDoesFire < Data.define(:config)
    def call(params) = true
  end

  class Automations::ConfiguredAutomation < Data.define(:config)
    def call(params) = config[:should_fire]
  end

  class Automations::ReturnsParams < Data.define(:config)
    def call(params) = params
  end

  class Automations::SaysHello < Data.define(:config)
    def call(params) = {greeting: "Hello #{params[:name]}"}
  end

  class Automations::AddsFirst < Data.define(:config)
    def call(params) = {first: "One"}
  end

  class Automations::AddsSecond < Data.define(:config)
    def call(params) = {second: "Two"}
  end

  class Automations::ReplacesSecond < Data.define(:config)
    def call(params) = {second: 2}
  end

  class Automations::ConfiguredAction < Data.define(:config)
    def call(params) = {config[:key].to_sym => config[:value]}
  end

  class Automations::RaisesException < Data.define(:config)
    def call(params)
      raise "BOOM"
    end
  end
  # standard:enable Lint/ConstantDefinitionInBlock

  context "trigger does not fire" do
    it "does nothing" do
      config = {
        name: "Trigger does not fire",
        class_name: "Automations::TriggerDoesNotFire",
        configuration: {},
        actions: [
          {class_name: "Automations::RaisesException", configuration: {}}
        ]
      }

      expect { described_class.new(config).call }.not_to raise_exception
      expect(described_class.new(config).call).to eq({})
    end

    it "uses the configuration when building the automation" do
      config = {
        name: "Automation configuration",
        class_name: "Automations::ConfiguredAutomation",
        configuration: {should_fire: false},
        actions: [
          {class_name: "Automations::RaisesException", configuration: {}}
        ]
      }

      expect { described_class.new(config).call }.not_to raise_exception
      expect(described_class.new(config).call).to eq({})
    end
  end

  context "trigger does fire" do
    it "uses the configuration when building the automation" do
      config = {
        name: "Automation configuration",
        class_name: "Automations::ConfiguredAutomation",
        configuration: {should_fire: true},
        actions: [
          {class_name: "Automations::ReturnsParams", configuration: {}}
        ]
      }

      result = described_class.new(config).call(name: "Alice")

      expect(result).to eq({name: "Alice"})
    end

    it "returns the provided parameters" do
      config = {
        name: "Returns the parameters",
        class_name: "Automations::TriggerDoesFire",
        configuration: {},
        actions: [
          {class_name: "Automations::ReturnsParams", configuration: {}}
        ]
      }

      result = described_class.new(config).call(name: "Alice")

      expect(result).to eq({name: "Alice"})
    end

    it "uses the parameters to generate the result" do
      config = {
        name: "Uses the parameters",
        class_name: "Automations::TriggerDoesFire",
        configuration: {},
        actions: [
          {class_name: "Automations::SaysHello", configuration: {}}
        ]
      }

      result = described_class.new(config).call(name: "Alice")

      expect(result).to eq({name: "Alice", greeting: "Hello Alice"})
    end

    it "returns the results from a sequence of actions" do
      config = {
        name: "Sequence of actions",
        class_name: "Automations::TriggerDoesFire",
        configuration: {},
        actions: [
          {class_name: "Automations::AddsFirst", configuration: {}},
          {class_name: "Automations::AddsSecond", configuration: {}}
        ]
      }

      result = described_class.new(config).call(name: "Alice")

      expect(result).to eq({name: "Alice", first: "One", second: "Two"})
    end

    it "replaces the results from a sequence of actions" do
      config = {
        name: "Sequence of actions",
        class_name: "Automations::TriggerDoesFire",
        configuration: {},
        actions: [
          {class_name: "Automations::AddsFirst", configuration: {}},
          {class_name: "Automations::AddsSecond", configuration: {}},
          {class_name: "Automations::ReplacesSecond", configuration: {}}
        ]
      }

      result = described_class.new(config).call(name: "Alice")

      expect(result).to eq({name: "Alice", first: "One", second: 2})
    end

    it "uses the configuration when building an action" do
      config = {
        name: "Action configuration",
        class_name: "Automations::TriggerDoesFire",
        configuration: {},
        actions: [
          {class_name: "Automations::ConfiguredAction", configuration: {key: "some", value: "data"}}
        ]
      }

      result = described_class.new(config).call(name: "Alice")

      expect(result).to eq({name: "Alice", some: "data"})
    end

    it "passes any exceptions raised back to the caller" do
      config = {
        name: "Exception handling",
        class_name: "Automations::TriggerDoesFire",
        configuration: {},
        actions: [
          {class_name: "Automations::RaisesException", configuration: {}}
        ]
      }

      expect { described_class.new(config).call }.to raise_exception(RuntimeError)
    end
  end
end
