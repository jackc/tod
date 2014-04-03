require File.expand_path(File.join(File.dirname(__FILE__),'..','test_helper'))
require 'active_support/time'

class TimeOfDayTest < Test::Unit::TestCase
  context "initialize" do
    should "block invalid hours" do
      assert_raise(ArgumentError) { TimeOfDay.new -1 }
      assert_raise(ArgumentError) { TimeOfDay.new 24 }
    end

    should "block invalid minutes" do
      assert_raise(ArgumentError) { TimeOfDay.new 0, -1 }
      assert_raise(ArgumentError) { TimeOfDay.new 0, 60 }
    end

    should "block invalid seconds" do
      assert_raise(ArgumentError) { TimeOfDay.new 0, 0, -1 }
      assert_raise(ArgumentError) { TimeOfDay.new 0, 0, 60 }
    end
  end

  context "second_of_day" do
    should "be 0 at midnight" do
      assert_equal 0, TimeOfDay.new(0,0,0).second_of_day
    end

    should "be 3661 at 1:01:01" do
      assert_equal 3661, TimeOfDay.new(1,1,1).second_of_day
    end

    should "be 86399 at last second of day" do
      assert_equal 86399, TimeOfDay.new(23,59,59).second_of_day
    end

    should "have alias to_i" do
      tod = TimeOfDay.new(0,0,0)
      assert_equal tod.method(:second_of_day), tod.method(:to_i)
    end
  end

  def self.should_parse(parse_string, expected_hour, expected_minute, expected_second)
    expected_tod = TimeOfDay.new expected_hour, expected_minute, expected_second

    should "parse '#{parse_string}' into #{expected_tod.inspect}" do
      assert_equal true, TimeOfDay.parsable?(parse_string)
      assert_equal expected_tod, TimeOfDay.try_parse(parse_string)
      assert_equal expected_tod, TimeOfDay.parse(parse_string)
    end
  end

  def self.should_not_parse(parse_string)
    should "not parse '#{parse_string}'" do
      assert_equal false, TimeOfDay.parsable?(parse_string)
      assert_equal nil, TimeOfDay.try_parse(parse_string)
      assert_raise(ArgumentError) { TimeOfDay.parse(parse_string) }
    end
  end

  should_parse "9",            9, 0, 0
  should_parse "13",          13, 0, 0
  should_parse "1230",        12,30, 0
  should_parse "08:15",        8,15, 0
  should_parse "08:15:30",     8,15,30
  should_parse "18",          18, 0, 0
  should_parse "23",          23, 0, 0

  should_parse "9a",           9, 0, 0
  should_parse "900a",         9, 0, 0
  should_parse "9A",           9, 0, 0
  should_parse "9am",          9, 0, 0
  should_parse "9AM",          9, 0, 0
  should_parse "9 a",          9, 0, 0
  should_parse "9 am",         9, 0, 0
  should_parse "09:30:45 am",  9,30,45

  should_parse "9p",          21, 0, 0
  should_parse "900p",        21, 0, 0
  should_parse "9P",          21, 0, 0
  should_parse "9pm",         21, 0, 0
  should_parse "9PM",         21, 0, 0
  should_parse "9 p",         21, 0, 0
  should_parse "9 pm",        21, 0, 0
  should_parse "09:30:45 pm", 21,30,45

  should_parse "12a",          0, 0, 0
  should_parse "12p",         12, 0, 0

  should_not_parse "-1:30"
  should_not_parse "24:00:00"
  should_not_parse "24"
  should_not_parse "00:60"
  should_not_parse "00:00:60"
  should_not_parse "13a"
  should_not_parse "13p"
  should_not_parse "10.5"
  should_not_parse "abc"
  should_not_parse ""
  should_not_parse []

  should "not parse 'nil'" do
    assert_equal false, TimeOfDay.parsable?(nil)
    assert_equal nil, TimeOfDay.try_parse(nil)
    assert_raise(ArgumentError) { TimeOfDay.parse(nil) }
  end

  should "provide spaceship operator" do
    assert_equal -1, TimeOfDay.new(8,0,0) <=> TimeOfDay.new(9,0,0)
    assert_equal 0, TimeOfDay.new(9,0,0) <=> TimeOfDay.new(9,0,0)
    assert_equal 1, TimeOfDay.new(10,0,0) <=> TimeOfDay.new(9,0,0)
  end

  should "compare equality by value" do
    assert_equal TimeOfDay.new(8,0,0), TimeOfDay.new(8,0,0)
  end


  context "strftime" do
    should "delegate to Time.parse" do
      format_string = "%H:%M"
      Time.any_instance.expects(:strftime).with(format_string)
      TimeOfDay.new(8,15,30).strftime format_string
    end
  end

  context "to_s" do
    should "format to HH:MM:SS" do
      assert_equal "08:15:30", TimeOfDay.new(8,15,30).to_s
      assert_equal "22:10:45", TimeOfDay.new(22,10,45).to_s
    end
  end

  context "to_i" do
    should "format to integer" do
      assert_equal 29730, TimeOfDay.new(8,15,30).to_i
      assert TimeOfDay.new(22,10,45).to_i.is_a? Integer
    end
  end

  context "addition" do
    should "add seconds" do
      original = TimeOfDay.new(8,0,0)
      result = original + 15
      assert_equal TimeOfDay.new(8,0,15), result
    end

    should "wrap around midnight" do
      original = TimeOfDay.new(23,0,0)
      result = original + 7200
      assert_equal TimeOfDay.new(1,0,0), result
    end

    should "return new TimeOfDay" do
      original = TimeOfDay.new(8,0,0)
      result = original + 15
      assert_not_equal original.object_id, result.object_id
    end
  end

  context "subtraction" do
    should "subtract seconds" do
      original = TimeOfDay.new(8,0,0)
      result = original - 15
      assert_equal TimeOfDay.new(7,59,45), result
    end

    should "wrap around midnight" do
      original = TimeOfDay.new(1,0,0)
      result = original - 7200
      assert_equal TimeOfDay.new(23,0,0), result
    end

    should "return new TimeOfDay" do
      original = TimeOfDay.new(8,0,0)
      result = original - 15
      assert_not_equal original.object_id, result.object_id
    end
  end

  context "from_second_of_day" do
    should "handle positive numbers" do
      assert_equal TimeOfDay.new(0,0,30), TimeOfDay.from_second_of_day(30)
      assert_equal TimeOfDay.new(0,1,30), TimeOfDay.from_second_of_day(90)
      assert_equal TimeOfDay.new(1,1,5), TimeOfDay.from_second_of_day(3665)
      assert_equal TimeOfDay.new(23,59,59), TimeOfDay.from_second_of_day(86399)
    end

    should "handle positive numbers a day or more away" do
      assert_equal TimeOfDay.new(0,0,0), TimeOfDay.from_second_of_day(86400)
      assert_equal TimeOfDay.new(0,0,30), TimeOfDay.from_second_of_day(86430)
      assert_equal TimeOfDay.new(0,1,30), TimeOfDay.from_second_of_day(86490)
      assert_equal TimeOfDay.new(1,1,5), TimeOfDay.from_second_of_day(90065)
      assert_equal TimeOfDay.new(23,59,59), TimeOfDay.from_second_of_day(172799)
    end

    should "handle negative numbers" do
      assert_equal TimeOfDay.new(23,59,30), TimeOfDay.from_second_of_day(-30)
    end

    should "handle negative numbers more than a day away" do
      assert_equal TimeOfDay.new(23,59,30), TimeOfDay.from_second_of_day(-86430)
    end

    should "have alias from_i" do
      assert_equal TimeOfDay.method(:from_second_of_day), TimeOfDay.method(:from_i)
    end
  end

  context "on" do
    should "be local Time on given date" do
      assert_equal Time.local(2010,12,29, 8,30), TimeOfDay.new(8,30).on(Date.civil(2010,12,29))
    end

    context "with a time zone" do
      should "be TimeWithZone on given date" do
        date = Date.civil 2000,1,1
        tod = TimeOfDay.new 8,30
        time_zone = ActiveSupport::TimeZone['Eastern Time (US & Canada)']
        assert_equal time_zone.local(2000,1,1, 8,30), tod.on(date, time_zone)
      end
    end
  end
end
