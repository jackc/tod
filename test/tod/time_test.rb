require_relative '../test_helper'

describe "Time extensions" do
  describe "#to_time_of_day" do
    it "is Tod::TimeOfDay" do
      time = Time.local 2000,1,1, 12,30,15
      assert_equal Tod::TimeOfDay.new(12,30,15), time.to_time_of_day
    end
  end
end
