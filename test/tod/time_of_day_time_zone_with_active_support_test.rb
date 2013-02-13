require File.expand_path(File.join(File.dirname(__FILE__),'..','test_helper'))
require 'active_support/time'

class TimeOfDayWithActiveSupportTest < Test::Unit::TestCase
  context "self.time_zone" do
    context "when Time.zone is nil" do
      should "be Time" do
        assert_equal Time, TimeOfDay.time_zone
      end
    end

    context "when Time.zone is set" do
      should "be Time.zone" do
        Time.zone = "Central Time (US & Canada)"
        assert_equal Time.zone, TimeOfDay.time_zone
      end
    end
  end
end
