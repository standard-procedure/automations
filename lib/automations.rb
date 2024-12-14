# frozen_string_literal: true

module Automations
  class Error < StandardError; end
  require_relative "automations/version"
  require_relative "automations/implementation"

  def self.create(config = {}) = Implementation.new(config)

  require_relative "automations/core_ext"
  require_relative "automations/annual_schedule"
  require_relative "automations/daily_schedule"
  require_relative "automations/monthly_schedule"
  require_relative "automations/weekly_schedule"
end
