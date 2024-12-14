# frozen_string_literal: true

module Automations
  class Error < StandardError; end
  require_relative "automations/version"
  require_relative "automations/implementation"

  def self.create(config = {}) = Implementation.new(config)
end
