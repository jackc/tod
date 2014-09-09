require File.expand_path(File.join(File.dirname(__FILE__),'..','test_helper'))
require 'active_support/time'

class TimeOfDayConversionTest < Test::Unit::TestCase
  should "handle TimeOfDay" do
    t   = TimeOfDay.new(13, 56, 12)
    tod = TimeOfDay(t)

    assert_equal(t, tod)
  end
  should "handle Time" do
    t   = Time.new(2014, 2, 27, 12, 01, 02)
    tod = TimeOfDay(t)

    assert_equal(tod, TimeOfDay.new(12, 01, 02))
  end
  should "handle Date" do
    t   = Date.new(2014, 2, 27)
    tod = TimeOfDay(t)

    assert_equal(tod, TimeOfDay.new(0, 0, 0))
  end
  should "handle DateTime" do
    t   = DateTime.new(2014, 2, 27, 12, 01, 02)
    tod = TimeOfDay(t)

    assert_equal(tod, TimeOfDay.new(12, 01, 02))
  end
  should "string" do
    t   = "12:01:02"
    tod = TimeOfDay(t)

    assert_equal(tod, TimeOfDay.new(12, 01, 02))
  end
  should "parse 'noon'" do
    t   = "noon"
    tod = TimeOfDay(t)

    assert_equal(tod, TimeOfDay.new(12, 00, 00))
  end
  should "parse 'midnight'" do
    t   = "midnight"
    tod = TimeOfDay(t)

    assert_equal(tod, TimeOfDay.new(0, 00, 00))
  end

end