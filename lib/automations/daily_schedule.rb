module Automations
  class DailySchedule < Data.define(:config)
    include Validations

    def call params = {}
      params.key?(:time) && days.include?(params[:time].wday) && times.include?(params[:time].hour)
    end

    def days = config[:days]

    def times = config[:times]

    def initialize(config)
      super
      validate_days_of_the_week days
      validate_times times
    end

    def to_s = "Daily - D: #{days.inspect}, T: #{times.inspect}"
  end
end
