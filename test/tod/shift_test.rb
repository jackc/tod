require File.expand_path(File.join(File.dirname(__FILE__),'..','test_helper'))
require 'active_support/time'

class ShiftTest < Test::Unit::TestCase
  context "duration" do
    should "return correct duration when first time is lower than the second one" do
      duration_expected = 4 * 60 * 60 + 30 * 60 + 30 # 4 hours, 30 min and 30 sec later
      tod1 = TimeOfDay.new 8,30
      tod2 = TimeOfDay.new 13,00,30
      shift = Shift.new tod1, tod2
      duration = shift.duration
      assert_equal duration, duration_expected
    end
    should "return correct duration when first time is greater than the second one" do
      duration_expected = 4 * 60 * 60 + 30 * 60 + 30 # 4 hours, 30 min and 30 sec later
      tod1 = TimeOfDay.new 22,30
      tod2 = TimeOfDay.new 3,00,30
      shift = Shift.new tod1, tod2
      duration = shift.duration
      assert_equal duration, duration_expected
    end
    should "be zero when both times are equal" do
      tod1 = TimeOfDay.new 3,00,30
      shift = Shift.new tod1, tod1
      duration = shift.duration
      assert_equal duration, 0
    end
  end

  context "include?" do
    # |------------------------|--------T1----V----T2----|------------------------|
    should "be true when value is between ToDs and boths tods are in the same day" do
      tod1  = TimeOfDay.new 8
      tod2  = TimeOfDay.new 16
      value = TimeOfDay.new 12
      shift = Shift.new tod1, tod2
      assert_equal shift.include?(value), true
    end

    # |------------------T1----|-------V----------T2-----|------------------------|
    should "be true when value is on second day between ToDs and start ToD is in a different day" do
      tod1  = TimeOfDay.new 20
      tod2  = TimeOfDay.new 15
      value = TimeOfDay.new 12
      shift = Shift.new tod1, tod2
      assert_equal shift.include?(value), true
    end

    # |------------------T1--V-|------------------T2-----|------------------------|
    should "be true when value is on first day between ToDs and start ToD is in a different day" do
      tod1  = TimeOfDay.new 20
      tod2  = TimeOfDay.new 15
      value = TimeOfDay.new 22
      shift = Shift.new tod1, tod2
      assert_equal shift.include?(value), true
    end

    # |------------------------|--------T1----------V----|----T2------------------|
    should "be true when value is on first day between ToDs and end ToD is in a different day" do
      tod1  = TimeOfDay.new 16
      tod2  = TimeOfDay.new 4
      value = TimeOfDay.new 20
      shift = Shift.new tod1, tod2
      assert_equal shift.include?(value), true
    end

    # |------------------------|--------T1---------------|--V---T2----------------|
    should "be true when value is on second day between ToDs and end ToD is in a different day" do
      tod1  = TimeOfDay.new 16
      tod2  = TimeOfDay.new 4
      value = TimeOfDay.new 2
      shift = Shift.new tod1, tod2
      assert_equal shift.include?(value), true
    end

    # |------------------------|--------T1-----T2----V---|------------------------|
    should "be false when value is after second ToD" do
      tod1  = TimeOfDay.new 10
      tod2  = TimeOfDay.new 16
      value = TimeOfDay.new 20
      shift = Shift.new tod1, tod2
      assert_equal shift.include?(value), false
    end

    # |------------------------|--V-----T1-----T2--------|------------------------|
    should "be false when value is before first ToD" do
      tod1  = TimeOfDay.new 10
      tod2  = TimeOfDay.new 16
      value = TimeOfDay.new 8
      shift = Shift.new tod1, tod2
      assert_equal shift.include?(value), false
    end
  end
end
