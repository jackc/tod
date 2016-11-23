require_relative '../test_helper'

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

  describe "overlaps?" do
    it "is true when shifts overlap" do
      shift1 = Tod::Shift.new(Tod::TimeOfDay.new(12), Tod::TimeOfDay.new(18))
      shift2 = Tod::Shift.new(Tod::TimeOfDay.new(13), Tod::TimeOfDay.new(15))
      assert shift1.overlaps?(shift2)

      # Additional Testing for Shifts that span from one day to another
      cases = [
        [5, 8, 7, 2],
        [7, 2, 1, 8],
        [7, 2, 5, 8],
        [4, 8, 1, 5],
        [1, 5, 4, 8],
        [7, 2, 1, 4],
        [1, 4, 7, 2],
        [1, 4, 3, 2],
        [5, 8, 7, 2],
        [7, 2, 8, 3],
        [7, 2, 6, 3],
        [7, 2, 1, 8]
      ]

      cases.each do |c|
        shift1 = Tod::Shift.new(Tod::TimeOfDay.new(c[0]), Tod::TimeOfDay.new(c[1]))
        shift2 = Tod::Shift.new(Tod::TimeOfDay.new(c[2]), Tod::TimeOfDay.new(c[3]))
        assert shift1.overlaps?(shift2), "Failed with args: #{c}"
      end
    end

    it "is false when shifts don't overlap" do
      shift1 = Tod::Shift.new(Tod::TimeOfDay.new(1), Tod::TimeOfDay.new(5))
      shift2 = Tod::Shift.new(Tod::TimeOfDay.new(9), Tod::TimeOfDay.new(12))
      refute shift1.overlaps?(shift2)

      # Additional Testing for Shifts that span from one day to another
      cases = [
        [7, 8, 1, 5],
        [1, 5, 7, 8],
        [7, 2, 3, 4],
        [3, 4, 5, 2],
        [1, 5, 9, 12]
      ]

      cases.each do |c|
        shift1 = Tod::Shift.new(Tod::TimeOfDay.new(c[0]), Tod::TimeOfDay.new(c[1]))
        shift2 = Tod::Shift.new(Tod::TimeOfDay.new(c[2]), Tod::TimeOfDay.new(c[3]))
        refute shift1.overlaps?(shift2), "Failed with args: #{c}"
      end
    end

    it "is true when shifts touch with inclusive end" do
      shift1 = Tod::Shift.new(Tod::TimeOfDay.new(1), Tod::TimeOfDay.new(5))
      shift2 = Tod::Shift.new(Tod::TimeOfDay.new(5), Tod::TimeOfDay.new(12))
      assert shift1.overlaps?(shift2)
    end

    it "is false when shifts touch with exclusive end" do
      shift1 = Tod::Shift.new(Tod::TimeOfDay.new(1), Tod::TimeOfDay.new(5), true)
      shift2 = Tod::Shift.new(Tod::TimeOfDay.new(5), Tod::TimeOfDay.new(12), true)
      refute shift1.overlaps?(shift2)
    end
  end

  describe "contains?" do
    it "is true when one shift contains another" do
      outside = Tod::Shift.new(Tod::TimeOfDay.new(12), Tod::TimeOfDay.new(18))
      inside = Tod::Shift.new(Tod::TimeOfDay.new(13), Tod::TimeOfDay.new(15))
      assert outside.contains?(inside)
    end

    it "is false when a shift is contained by another" do
      outside = Tod::Shift.new(Tod::TimeOfDay.new(12), Tod::TimeOfDay.new(18))
      inside = Tod::Shift.new(Tod::TimeOfDay.new(13), Tod::TimeOfDay.new(15))
      refute inside.contains?(outside)
    end

    it "is false when shifts don't even overlap" do
      shift1 = Tod::Shift.new(Tod::TimeOfDay.new(12), Tod::TimeOfDay.new(15))
      shift2 = Tod::Shift.new(Tod::TimeOfDay.new(18), Tod::TimeOfDay.new(19))
      refute shift1.contains?(shift2)
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

  describe "#==" do
    it "is true when the beginning time, end time, and exclude end are the same" do
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift1 = Tod::Shift.new tod1, tod2
      shift2 = Tod::Shift.new tod1, tod2
      assert shift1 == shift2
    end

    it "is false when the beginning time is different" do
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift1 = Tod::Shift.new tod1, tod2
      shift2 = Tod::Shift.new tod1, Tod::TimeOfDay.new(14,00)
      assert !(shift1 == shift2)
    end

    it "is false when the ending time is different" do
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift1 = Tod::Shift.new tod1, tod2
      shift2 = Tod::Shift.new Tod::TimeOfDay.new(9,30), tod2
      assert !(shift1 == shift2)
    end

    it "is false when exclude end is different" do
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift1 = Tod::Shift.new tod1, tod2
      shift2 = Tod::Shift.new tod1, tod2, true
      assert !(shift1 == shift2)
    end
  end

  describe "#eql?" do
    it "is true when the beginning time, end time, and exclude end are the same" do
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift1 = Tod::Shift.new tod1, tod2
      shift2 = Tod::Shift.new tod1, tod2
      assert shift1.eql?(shift2)
    end

    it "is false when the beginning time is different" do
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift1 = Tod::Shift.new tod1, tod2
      shift2 = Tod::Shift.new tod1, Tod::TimeOfDay.new(14,00)
      assert !shift1.eql?(shift2)
    end

    it "is false when the ending time is different" do
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift1 = Tod::Shift.new tod1, tod2
      shift2 = Tod::Shift.new Tod::TimeOfDay.new(9,30), tod2
      assert !shift1.eql?(shift2)
    end

    it "is false when exclude end is different" do
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift1 = Tod::Shift.new tod1, tod2
      shift2 = Tod::Shift.new tod1, tod2, true
      assert !shift1.eql?(shift2)
    end
  end

  describe "#hash" do
    it "is the same when the beginning time, end time, and exclude end are the same" do
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift1 = Tod::Shift.new tod1, tod2
      shift2 = Tod::Shift.new tod1, tod2
      assert_equal shift1.hash, shift2.hash
    end

    it "is usually different when the beginning time is different" do
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift1 = Tod::Shift.new tod1, tod2
      shift2 = Tod::Shift.new tod1, Tod::TimeOfDay.new(14,00)
      assert shift1.hash != shift2.hash
    end

    it "is usually different when the ending time is different" do
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift1 = Tod::Shift.new tod1, tod2
      shift2 = Tod::Shift.new Tod::TimeOfDay.new(9,30), tod2
      assert shift1.hash != shift2.hash
    end

    it "is usually different when exclude end is different" do
      tod1 = Tod::TimeOfDay.new 8,30
      tod2 = Tod::TimeOfDay.new 13,00,30
      shift1 = Tod::Shift.new tod1, tod2
      shift2 = Tod::Shift.new tod1, tod2, true
      assert shift1.hash != shift2.hash
    end
  end

  describe "slide" do
    it "handles positive numbers" do
      slide = 30 * 60 # 30 minutes in seconds

      beginning_expected = Tod::TimeOfDay.new 10, 30
      ending_expected = Tod::TimeOfDay.new 16, 30

      beginning  = Tod::TimeOfDay.new 10
      ending  = Tod::TimeOfDay.new 16
      shift = Tod::Shift.new(beginning, ending, false).slide(slide)

      assert_equal beginning_expected, shift.beginning
      assert_equal ending_expected, shift.ending
      refute shift.exclude_end?
    end

    it "handles negative numbers" do
      slide = -30 * 60 # -30 minutes in seconds

      beginning_expected = Tod::TimeOfDay.new 9, 30
      ending_expected = Tod::TimeOfDay.new 15, 30

      beginning  = Tod::TimeOfDay.new 10
      ending  = Tod::TimeOfDay.new 16
      shift = Tod::Shift.new(beginning, ending, false).slide(slide)

      assert_equal beginning_expected, shift.beginning
      assert_equal ending_expected, shift.ending
      refute shift.exclude_end?
    end

    it "handles ActiveSupport::Duration" do
      slide = 30.minutes

      beginning_expected = Tod::TimeOfDay.new 10, 30
      ending_expected = Tod::TimeOfDay.new 16, 30

      beginning  = Tod::TimeOfDay.new 10
      ending  = Tod::TimeOfDay.new 16
      shift = Tod::Shift.new(beginning, ending, false).slide(slide)

      assert_equal beginning_expected, shift.beginning
      assert_equal ending_expected, shift.ending
      refute shift.exclude_end?
    end
  end
end
