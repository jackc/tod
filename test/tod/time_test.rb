require File.expand_path(File.join(File.dirname(__FILE__),'..','test_helper'))

class TimeTest < Test::Unit::TestCase
  context "to_time_of_day" do
    should "be Tod::TimeOfDay" do
      time = Time.local 2000,1,1, 12,30,15
      assert_equal Tod::TimeOfDay.new(12,30,15), time.to_time_of_day
    end
  end
end
