require_relative '../test_helper'

describe "TimeOfDay()" do
  it "handles Tod::TimeOfDay" do
    t   = Tod::TimeOfDay.new(13, 56, 12)
    tod = Tod::TimeOfDay(t)

    assert_equal(t, tod)
  end

  it "handles Time" do
    t   = Time.new(2014, 2, 27, 12, 01, 02)
    tod = Tod::TimeOfDay(t)

    assert_equal(tod, Tod::TimeOfDay.new(12, 01, 02))
  end

  it "handles Date" do
    t   = Date.new(2014, 2, 27)
    tod = Tod::TimeOfDay(t)

    assert_equal(tod, Tod::TimeOfDay.new(0, 0, 0))
  end

  it "handles DateTime" do
    t   = DateTime.new(2014, 2, 27, 12, 01, 02)
    tod = Tod::TimeOfDay(t)

    assert_equal(tod, Tod::TimeOfDay.new(12, 01, 02))
  end

  describe "without core extensions" do
    it "handles Time" do
      t   = Time.new(2014, 2, 27, 12, 01, 02)
      class <<t
        undef_method(:to_time_of_day)
      end
      tod = Tod::TimeOfDay(t)

      assert_equal(tod, Tod::TimeOfDay.new(12, 01, 02))
    end

    it "handles Date" do
      t   = Date.new(2014, 2, 27)
      class <<t
        undef_method(:to_time_of_day)
      end
      tod = Tod::TimeOfDay(t)

      assert_equal(tod, Tod::TimeOfDay.new(0, 0, 0))
    end

    it "handles DateTime" do
      t   = DateTime.new(2014, 2, 27, 12, 01, 02)
      class <<t
        undef_method(:to_time_of_day)
      end
      tod = Tod::TimeOfDay(t)

      assert_equal(tod, Tod::TimeOfDay.new(12, 01, 02))
    end
  end

  it "parses string" do
    t   = "12:01:02"
    tod = Tod::TimeOfDay(t)

    assert_equal(tod, Tod::TimeOfDay.new(12, 01, 02))
  end

  it "parses 'noon'" do
    t   = "noon"
    tod = Tod::TimeOfDay(t)

    assert_equal(tod, Tod::TimeOfDay.new(12, 00, 00))
  end

  it "parses 'midnight'" do
    t   = "midnight"
    tod = Tod::TimeOfDay(t)

    assert_equal(tod, Tod::TimeOfDay.new(0, 00, 00))
  end
end
