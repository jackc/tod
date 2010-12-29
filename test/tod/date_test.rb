require File.expand_path(File.join(File.dirname(__FILE__),'..','test_helper'))

class DateTest < Test::Unit::TestCase
  context "at" do
    should "accept TimeOfDay and return Time on same date" do
      date = Date.civil 2000,1,1
      tod = TimeOfDay.new 8,30
      assert_equal Time.local(2000,1,1, 8,30), date.at(tod)
    end
  end
end
