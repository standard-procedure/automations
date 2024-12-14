module Automations
  class WeeklySchedule < Data.define(:config)
    include Validations

    def weeks = config[:weeks]

    def days = config[:days]

    def times = config[:times]

    def initialize(config)
      super
      validate_weeks weeks
      validate_days_of_the_week days
      validate_times times
    end

    def to_s = "Weekly - W: #{weeks.inspect}, D: #{days.inspect}, T: #{times.inspect}"

    def call(params = {}) = params.key?(:time) && weeks.include?(params[:time].week_of_month) && days.include?(params[:time].wday) && times.include?(params[:time].hour)
  end
end
