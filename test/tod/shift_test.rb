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
