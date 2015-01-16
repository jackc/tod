require File.expand_path(File.join(File.dirname(__FILE__),'..','test_helper'))
require 'active_support/time'

describe "TimeOfDay with ActiveSupport" do
  describe ".time_zone" do
    describe "when Time.zone is nil" do
      before do
        Time.zone = nil
      end

      it "is Time" do
        assert_equal Time, Tod::TimeOfDay.time_zone
      end
    end

    describe "when Time.zone is set" do
      before do
        Time.zone = "Central Time (US & Canada)"
      end

      it "is Time.zone" do
        assert_equal Time.zone, Tod::TimeOfDay.time_zone
      end
    end
  end
end
