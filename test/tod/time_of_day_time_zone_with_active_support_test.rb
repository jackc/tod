require_relative '../test_helper'

describe "TimeOfDay with ActiveSupport" do
  describe ".time_zone" do
    before do
      @orig_zone = Time.zone
    end

    after do
      Time.zone = @orig_zone
    end

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
