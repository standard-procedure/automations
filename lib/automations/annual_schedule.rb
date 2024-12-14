require_relative "validations"
module Automations
  class AnnualSchedule < Data.define(:config)
    include Validations

    def times = config[:times]

    def days = config[:days]

    def months = config[:months]

    def years = config[:years]

    def call(params = {}) = params.key?(:time) && months.include?(params[:time].month) && days.include?(params[:time].day) && times.include?(params[:time].hour)

    def initialize(config)
      super
      validate_months months
      validate_days_of_the_month days
      validate_times times
    end

    def to_s = "Annual - M: #{months.inspect}, D: #{days.inspect}, T: #{times.inspect}"
  end
end
