module Automations
  class MonthlySchedule < Data.define(:config)
    include Validations

    def days = config[:days]

    def times = config[:times]

    def call(params = {}) = params.key?(:time) && days.include?(params[:time].day) && times.include?(params[:time].hour)

    def initialize(config)
      super
      validate_days_of_the_month days
      validate_times times
    end

    def to_s = "Monthly - D: #{days.inspect}, T: #{times.inspect}"
  end
end
