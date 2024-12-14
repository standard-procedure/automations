require "spec_helper"

RSpec.describe Automations::MonthlySchedule do
  describe "#initialize" do
    it "accepts days between 1 and 31" do
      @schedule = Automations::MonthlySchedule.new({days: [1, 2], times: [10, 22]})

      expect(@schedule.days).to eq([1, 2])
    end

    it "does not accept days outside 1 and 31" do
      expect { Automations::MonthlySchedule.new({days: [-1, 2], times: [10, 22]}) }.to raise_error ArgumentError

      expect { Automations::MonthlySchedule.new({days: [1, 32], times: [10, 22]}) }.to raise_error ArgumentError
    end

    it "accepts times between 0 and 23" do
      @schedule = Automations::MonthlySchedule.new({days: [1, 2], times: [10, 22]})

      expect(@schedule.times).to eq([10, 22])
    end

    it "does not accept times outside 0 and 23" do
      expect { Automations::MonthlySchedule.new({days: [1, 2], times: [-1, 22]}) }.to raise_error ArgumentError

      expect { Automations::MonthlySchedule.new({days: [1, 2], times: [10, 25]}) }.to raise_error ArgumentError
    end
  end

  describe "#call" do
    it "must be supplied with a time" do
      @schedule = Automations::MonthlySchedule.new({days: [28], times: [11]})
      expect(@schedule.call(some: "data")).to be false
    end

    it "is ready if the day and time match" do
      @schedule = Automations::MonthlySchedule.new({days: [28], times: [11]})
      Timecop.travel Time.new(2024, 9, 28, 11, 0) do # Saturday, 28th September 2024, 11:00
        expect(@schedule.call(time: Time.now)).to be true
      end
    end

    it "is ready if the day matches and the time is within the following hour" do
      @schedule = Automations::MonthlySchedule.new({days: [28], times: [11]})
      Timecop.travel Time.new(2024, 9, 28, 11, 45) do # Saturday, 28th September 2024, 11:45
        expect(@schedule.call(time: Time.now)).to be true
      end
    end

    it "is not ready if the day does not match and the time matches" do
      @schedule = Automations::MonthlySchedule.new({days: [29], times: [11]})
      Timecop.travel Time.new(2024, 9, 28, 11, 0) do # Saturday, 28th September 2024, 11:00
        expect(@schedule.call(time: Time.now)).to be false
      end
    end

    it "is not ready if the day matches and the time does not match" do
      @schedule = Automations::MonthlySchedule.new({days: [28], times: [12]})
      Timecop.travel Time.new(2024, 9, 28, 11, 0) do # Saturday, 28thSeptember 2024, 11:00
        expect(@schedule.call(time: Time.now)).to be false
      end
    end
  end
end
