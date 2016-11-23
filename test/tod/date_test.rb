require_relative '../test_helper'

describe "Date extensions" do
  describe "#at" do
    it "accepts TimeOfDay and return Time on same date" do
      date = Date.civil 2000,1,1
      tod = Tod::TimeOfDay.new 8,30
      assert_equal Time.zone.local(2000,1,1, 8,30), date.at(tod)
    end

    describe "with a time zone" do
      it "accepts TimeOfDay and TimeWithZone on same date" do
        date = Date.civil 2000,1,1
        tod = Tod::TimeOfDay.new 8,30
        time_zone = ActiveSupport::TimeZone['Eastern Time (US & Canada)']
        assert_equal time_zone.local(2000,1,1, 8,30), date.at(tod, time_zone)
      end
    end
  end

  describe "#to_time_day" do
    it "is TimeOfDay" do
      date_time = DateTime.new 2013, 9, 19, 15, 17, 34
      assert_equal Tod::TimeOfDay.new(15, 17, 34), date_time.to_time_of_day
    end
  end
end
