module Automations
  class Implementation
    def initialize(config)
      @automation = build_automation(config)
      @actions = config[:actions].map { |action_config| build_action(action_config) }
    end

    def call(params = {}) = @automation.call(params) ? call_actions(params) : {}

    private

    def call_actions(params)
      @actions.each_with_object(params) do |action, result|
        result.merge!(action.call(result))
      end
    end

    def build_automation(config)
      Object.const_get(config[:class_name]).new(config[:configuration].transform_keys(&:to_sym))
    end

    def build_action(config)
      Object.const_get(config[:class_name]).new(config[:configuration].transform_keys(&:to_sym))
    end
  end
end
