require File.expand_path(File.join(File.dirname(__FILE__),'..','test_helper'))
require 'active_support/time'

describe "Shift" do
  describe "#initialize" do
    it "parses bounds" do
      shift = Tod::Shift.new Tod::TimeOfDay.new(8), Tod::TimeOfDay.new(10), false
      refute shift.exclude_end?

      shift = Tod::Shift.new Tod::TimeOfDay.new(8), Tod::TimeOfDay.new(10), true
      assert shift.exclude_end?
    end
  end

  describe "#duration" do
    it "returns correct duration when first time is lower than the second one" do
      duration_expected = 4 * 60 * 60 + 30 * 60 + 30 # 4 hours, 30 min and 30 sec later
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift = Tod::Shift.new tod1, tod2
      duration = shift.duration
      assert_equal duration, duration_expected
    end

    it "returns correct duration when first time is greater than the second one" do
      duration_expected = 4 * 60 * 60 + 30 * 60 + 30 # 4 hours, 30 min and 30 sec later
      tod1 = Tod::TimeOfDay.new 22,30
      tod2 = Tod::TimeOfDay.new 3,00,30
      shift = Tod::Shift.new tod1, tod2
      duration = shift.duration
      assert_equal duration, duration_expected
    end

    it "is zero when both times are equal" do
      tod1 = Tod::TimeOfDay.new 3,00,30
      shift = Tod::Shift.new tod1, tod1
      duration = shift.duration
      assert_equal duration, 0
    end
  end

  context "overlaps?" do
    should "be true when shifts overlap" do
      shift1 = Shift.new(TimeOfDay.new(12), TimeOfDay.new(18))
      shift2 = Shift.new(TimeOfDay.new(13), TimeOfDay.new(15))
      assert_true shift1.overlaps?(shift2)
    end

    should "be false when shifts don't overlap" do
      shift1 = Shift.new(TimeOfDay.new(1), TimeOfDay.new(5))
      shift2 = Shift.new(TimeOfDay.new(9), TimeOfDay.new(12))
      assert_false shift1.overlaps?(shift2)
    end

    should "be true when shifts touch" do
      shift1 = Shift.new(TimeOfDay.new(1), TimeOfDay.new(5))
      shift2 = Shift.new(TimeOfDay.new(5), TimeOfDay.new(12))
      assert_true shift1.overlaps?(shift2)
    end
  end

  context "contains?" do
    should "be true when one shift contains another" do
      outside = Shift.new(TimeOfDay.new(12), TimeOfDay.new(18))
      inside = Shift.new(TimeOfDay.new(13), TimeOfDay.new(15))
      assert_true outside.contains?(inside)
    end

    should "be false when a shift is contained by another" do
      outside = Shift.new(TimeOfDay.new(12), TimeOfDay.new(18))
      inside = Shift.new(TimeOfDay.new(13), TimeOfDay.new(15))
      assert_false inside.contains?(outside)
    end

    should "be false when shifts don't even overlap" do
      shift1 = Shift.new(TimeOfDay.new(12), TimeOfDay.new(15))
      shift2 = Shift.new(TimeOfDay.new(18), TimeOfDay.new(19))
      assert_false shift1.contains?(shift2)
    end
  end

  describe "#include?" do
    # |------------------------|--------T1----V----T2----|------------------------|
    it "is true when value is between ToDs and boths tods are in the same day" do
      tod1  = Tod::TimeOfDay.new 8
      tod2  = Tod::TimeOfDay.new 16
      value = Tod::TimeOfDay.new 12
      shift = Tod::Shift.new tod1, tod2
      assert shift.include?(value)
    end

    # |------------------T1----|-------V----------T2-----|------------------------|
    it "is true when value is on second day between ToDs and start ToD is in a different day" do
      tod1  = Tod::TimeOfDay.new 20
      tod2  = Tod::TimeOfDay.new 15
      value = Tod::TimeOfDay.new 12
      shift = Tod::Shift.new tod1, tod2
      assert shift.include?(value)
    end

    # |------------------T1--V-|------------------T2-----|------------------------|
    it "is true when value is on first day between ToDs and start ToD is in a different day" do
      tod1  = Tod::TimeOfDay.new 20
      tod2  = Tod::TimeOfDay.new 15
      value = Tod::TimeOfDay.new 22
      shift = Tod::Shift.new tod1, tod2
      assert shift.include?(value)
    end

    # |------------------------|--------T1----------V----|----T2------------------|
    it "is true when value is on first day between ToDs and end ToD is in a different day" do
      tod1  = Tod::TimeOfDay.new 16
      tod2  = Tod::TimeOfDay.new 4
      value = Tod::TimeOfDay.new 20
      shift = Tod::Shift.new tod1, tod2
      assert shift.include?(value)
    end

    # |------------------------|--------T1---------------|--V---T2----------------|
    it "is true when value is on second day between ToDs and end ToD is in a different day" do
      tod1  = Tod::TimeOfDay.new 16
      tod2  = Tod::TimeOfDay.new 4
      value = Tod::TimeOfDay.new 2
      shift = Tod::Shift.new tod1, tod2
      assert shift.include?(value)
    end

    # |------------------------|--------T1-----T2----V---|------------------------|
    it "is false when value is after second ToD" do
      tod1  = Tod::TimeOfDay.new 10
      tod2  = Tod::TimeOfDay.new 16
      value = Tod::TimeOfDay.new 20
      shift = Tod::Shift.new tod1, tod2
      refute shift.include?(value)
    end

    # |------------------------|--V-----T1-----T2--------|------------------------|
    it "is false when value is before first ToD" do
      tod1  = Tod::TimeOfDay.new 10
      tod2  = Tod::TimeOfDay.new 16
      value = Tod::TimeOfDay.new 8
      shift = Tod::Shift.new tod1, tod2
      refute shift.include?(value)
    end

    # |------------------------|--------T1-----T2V-------|------------------------|
    it "is false when value is equal to second ToD and Shift is ending exclusive" do
      tod1  = Tod::TimeOfDay.new 10
      tod2  = Tod::TimeOfDay.new 16
      value = Tod::TimeOfDay.new 16
      shift = Tod::Shift.new tod1, tod2, true
      refute shift.include?(value)
    end

    # |------------------------|--------T1-----T2V-------|------------------------|
    it "is true when value is equal to second ToD and Shift is ending inclusive" do
      tod1  = Tod::TimeOfDay.new 10
      tod2  = Tod::TimeOfDay.new 16
      value = Tod::TimeOfDay.new 16
      shift = Tod::Shift.new tod1, tod2, false
      assert shift.include?(value)
    end
  end
end
