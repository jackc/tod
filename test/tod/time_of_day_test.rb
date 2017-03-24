require_relative '../test_helper'

describe "TimeOfDay" do
  describe "#initialize" do
    it "blocks invalid hours" do
      assert_raises(ArgumentError) { Tod::TimeOfDay.new(-1) }
      assert_raises(ArgumentError) { Tod::TimeOfDay.new 24 }
    end

    it "blocks invalid minutes" do
      assert_raises(ArgumentError) { Tod::TimeOfDay.new 0, -1 }
      assert_raises(ArgumentError) { Tod::TimeOfDay.new 0, 60 }
    end

    it "blocks invalid seconds" do
      assert_raises(ArgumentError) { Tod::TimeOfDay.new 0, 0, -1 }
      assert_raises(ArgumentError) { Tod::TimeOfDay.new 0, 0, 60 }
    end
  end

  describe "second_of_day" do
    it "is 0 at midnight" do
      assert_equal 0, Tod::TimeOfDay.new(0,0,0).second_of_day
    end

    it "is 3661 at 1:01:01" do
      assert_equal 3661, Tod::TimeOfDay.new(1,1,1).second_of_day
    end

    it "is 86399 at last second of day" do
      assert_equal 86399, Tod::TimeOfDay.new(23,59,59).second_of_day
    end

    it "have alias to_i" do
      tod = Tod::TimeOfDay.new(0,0,0)
      assert_equal tod.method(:second_of_day), tod.method(:to_i)
    end
  end

  def self.should_parse(parse_string, expected_hour, expected_minute, expected_second)
    expected_tod = Tod::TimeOfDay.new expected_hour, expected_minute, expected_second

    it "parses '#{parse_string}' into #{expected_tod.inspect}" do
      assert_equal true, Tod::TimeOfDay.parsable?(parse_string)
      assert_equal expected_tod, Tod::TimeOfDay.try_parse(parse_string)
      assert_equal expected_tod, Tod::TimeOfDay.parse(parse_string)
    end
  end

  def self.should_not_parse(parse_string)
    it "does not parse '#{parse_string}'" do
      assert_equal false, Tod::TimeOfDay.parsable?(parse_string)
      assert_nil Tod::TimeOfDay.try_parse(parse_string)
      assert_raises(ArgumentError) { Tod::TimeOfDay.parse(parse_string) }
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

  it "does not parse 'nil'" do
    assert_equal false, Tod::TimeOfDay.parsable?(nil)
    assert_nil Tod::TimeOfDay.try_parse(nil)
    assert_raises(ArgumentError) { Tod::TimeOfDay.parse(nil) }
  end

  it "provides spaceship operator" do
    assert_equal(-1, Tod::TimeOfDay.new(8,0,0) <=> Tod::TimeOfDay.new(9,0,0))
    assert_equal 0, Tod::TimeOfDay.new(9,0,0) <=> Tod::TimeOfDay.new(9,0,0)
    assert_equal 1, Tod::TimeOfDay.new(10,0,0) <=> Tod::TimeOfDay.new(9,0,0)
  end

  it "compares equality by value" do
    assert_equal Tod::TimeOfDay.new(8,0,0), Tod::TimeOfDay.new(8,0,0)
  end

  describe "round_nearest" do
    it "rounds to the given nearest number of seconds" do
      assert_equal Tod::TimeOfDay.new(8,15,30), Tod::TimeOfDay.new(8,15,31).round(5)
      assert_equal Tod::TimeOfDay.new(8,15,35), Tod::TimeOfDay.new(8,15,33).round(5)
      assert_equal Tod::TimeOfDay.new(8,16,0), Tod::TimeOfDay.new(8,15,34).round(60)
      assert_equal Tod::TimeOfDay.new(8,15,0), Tod::TimeOfDay.new(8,15,15).round(60)
      assert_equal Tod::TimeOfDay.new(8,15,0), Tod::TimeOfDay.new(8,17,15).round(300)
      assert_equal Tod::TimeOfDay.new(8,20,0), Tod::TimeOfDay.new(8,18,15).round(300)
      assert_equal Tod::TimeOfDay.new(8,20,0), Tod::TimeOfDay.new(8,20,00).round(300)
      assert_equal Tod::TimeOfDay.new(9,0,0), Tod::TimeOfDay.new(8,58,00).round(300)
      assert_equal Tod::TimeOfDay.new(8,0,0), Tod::TimeOfDay.new(8,02,29).round(300)
      assert_equal Tod::TimeOfDay.new(0,0,0), Tod::TimeOfDay.new(23,58,29).round(300)
    end
  end

  describe "strftime" do
    it "accepts standard strftime format codes" do
      assert_equal "08:15", Tod::TimeOfDay.new(8,15,30).strftime("%H:%M")
    end
  end

  describe "to_s" do
    it "formats to HH:MM:SS" do
      assert_equal "08:15:30", Tod::TimeOfDay.new(8,15,30).to_s
      assert_equal "22:10:45", Tod::TimeOfDay.new(22,10,45).to_s
    end
  end

  describe "to_i" do
    it "formats to integer" do
      assert_equal 29730, Tod::TimeOfDay.new(8,15,30).to_i
      assert Tod::TimeOfDay.new(22,10,45).to_i.is_a? Integer
    end
  end

  describe "addition" do
    it "adds seconds" do
      original = Tod::TimeOfDay.new(8,0,0)
      result = original + 15
      assert_equal Tod::TimeOfDay.new(8,0,15), result
    end

    it "wraps around midnight" do
      original = Tod::TimeOfDay.new(23,0,0)
      result = original + 7200
      assert_equal Tod::TimeOfDay.new(1,0,0), result
    end

    it "returns new Tod::TimeOfDay" do
      original = Tod::TimeOfDay.new(8,0,0)
      result = original + 15
      refute_equal original.object_id, result.object_id
    end

    it "handles ActiveSupport::Duration" do
      original = Tod::TimeOfDay.new(8,0,0)
      result = original + 10.minutes
      assert_equal Tod::TimeOfDay.new(8,10,0), result
    end
  end

  describe "subtraction" do
    it "subtracts seconds" do
      original = Tod::TimeOfDay.new(8,0,0)
      result = original - 15
      assert_equal Tod::TimeOfDay.new(7,59,45), result
    end

    it "wraps around midnight" do
      original = Tod::TimeOfDay.new(1,0,0)
      result = original - 7200
      assert_equal Tod::TimeOfDay.new(23,0,0), result
    end

    it "returns new Tod::TimeOfDay" do
      original = Tod::TimeOfDay.new(8,0,0)
      result = original - 15
      refute_equal original.object_id, result.object_id
    end

    it "handles ActiveSupport::Duration" do
      original = Tod::TimeOfDay.new(8,0,0)
      result = original - 10.minutes
      assert_equal Tod::TimeOfDay.new(7,50,0), result
    end

    it "subtracts Tod::TimeOfDay object" do
      right_side = Tod::TimeOfDay.new(10,0,0)
      left_side = Tod::TimeOfDay.new(12,0,30)
      result = right_side - left_side
      assert_equal Tod::TimeOfDay.new(21,59,30), result
    end
  end

  describe "from_second_of_day" do
    it "handles positive numbers" do
      assert_equal Tod::TimeOfDay.new(0,0,30), Tod::TimeOfDay.from_second_of_day(30)
      assert_equal Tod::TimeOfDay.new(0,1,30), Tod::TimeOfDay.from_second_of_day(90)
      assert_equal Tod::TimeOfDay.new(1,1,5), Tod::TimeOfDay.from_second_of_day(3665)
      assert_equal Tod::TimeOfDay.new(23,59,59), Tod::TimeOfDay.from_second_of_day(86399)
    end

    it "handles positive numbers a day or more away" do
      assert_equal Tod::TimeOfDay.new(0,0,0), Tod::TimeOfDay.from_second_of_day(86400)
      assert_equal Tod::TimeOfDay.new(0,0,30), Tod::TimeOfDay.from_second_of_day(86430)
      assert_equal Tod::TimeOfDay.new(0,1,30), Tod::TimeOfDay.from_second_of_day(86490)
      assert_equal Tod::TimeOfDay.new(1,1,5), Tod::TimeOfDay.from_second_of_day(90065)
      assert_equal Tod::TimeOfDay.new(23,59,59), Tod::TimeOfDay.from_second_of_day(172799)
    end

    it "handles negative numbers" do
      assert_equal Tod::TimeOfDay.new(23,59,30), Tod::TimeOfDay.from_second_of_day(-30)
    end

    it "handles negative numbers more than a day away" do
      assert_equal Tod::TimeOfDay.new(23,59,30), Tod::TimeOfDay.from_second_of_day(-86430)
    end

    it "has alias from_i" do
      assert_equal Tod::TimeOfDay.method(:from_second_of_day), Tod::TimeOfDay.method(:from_i)
    end

    it "handles floats" do
      assert_equal Tod::TimeOfDay.new(15,30,0), Tod::TimeOfDay.from_second_of_day(55800.0)
    end
  end

  describe "on" do
    it "is local Time on given date" do
      assert_equal Time.zone.local(2010,12,29, 8,30), Tod::TimeOfDay.new(8,30).on(Date.civil(2010,12,29))
    end

    describe "with a time zone" do
      it "is TimeWithZone on given date" do
        date = Date.civil 2000,1,1
        tod = Tod::TimeOfDay.new 8,30
        time_zone = ActiveSupport::TimeZone['Eastern Time (US & Canada)']
        assert_equal time_zone.local(2000,1,1, 8,30), tod.on(date, time_zone)
      end
    end
  end
end
