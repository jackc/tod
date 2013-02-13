require File.expand_path(File.join(File.dirname(__FILE__),'..','test_helper'))
require 'active_support/time'

class DateTest < Test::Unit::TestCase
  context "at" do
    should "accept TimeOfDay and return Time on same date" do
      date = Date.civil 2000,1,1
      tod = TimeOfDay.new 8,30
      assert_equal Time.local(2000,1,1, 8,30), date.at(tod)
    end

    context "with a time zone" do
      should "accept TimeOfDay and TimeWithZone on same date" do
        date = Date.civil 2000,1,1
        tod = TimeOfDay.new 8,30
        time_zone = ActiveSupport::TimeZone['Eastern Time (US & Canada)']
        assert_equal time_zone.local(2000,1,1, 8,30), date.at(tod, time_zone)
      end
    end
  end
end
