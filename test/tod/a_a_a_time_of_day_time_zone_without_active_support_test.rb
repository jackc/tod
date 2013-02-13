# This test depends on not having ActiveSupport loaded yet. So it is named
# with AAA prefix to ensure it runs before anything that loads it.

require File.expand_path(File.join(File.dirname(__FILE__),'..','test_helper'))

class AAATimeOfDayWithoutActiveSupportTest < Test::Unit::TestCase
  context "self.time_zone" do
    should "be Time" do
      assert_equal Time, TimeOfDay.time_zone
    end
  end
end
