require_relative '../test_helper'
require File.expand_path(File.join(File.dirname(__FILE__),'..','support/active_record'))

class Order < ActiveRecord::Base
  serialize :time, Tod::TimeOfDay
end

describe "TimeOfDay with ActiveRecord Serializable Attribute" do
  describe ".dump" do
    it "sets time of day" do
      Order.create!(time: Tod::TimeOfDay.new(9, 30))
    end

    it "sets nil as value" do
      Order.create!(time: nil)
    end

    it "works with multiparam time arguments" do
      order = Order.create!({"time(4i)" => "8", "time(5i)" => "6", "time(6i)" => "5"})
      assert_equal Tod::TimeOfDay.new(8,6,5), order.time
    end
  end

  describe ".load" do
    it "loads set Tod::TimeOfDay" do
      time_of_day = Tod::TimeOfDay.new(9, 30)
      order = Order.create!(time: time_of_day)
      order.reload
      assert_equal order.time, time_of_day
    end

    it "loads set Time" do
      time_of_day = Time.new(2015, 10, 21, 16, 29, 0, "-07:00")
      order = Order.create!(time: time_of_day)
      order.reload
      assert_equal order.time, Tod::TimeOfDay.new(16, 29)
    end

    it "returns nil if time is not set" do
      order = Order.create!(time: nil)
      order.reload
      assert_nil order.time
    end
  end

  describe "Order.where" do
    it "handles TimeOfDay as a parameter" do
      tod = Tod::TimeOfDay.new(11, 11)
      expected = Order.create!(time: tod)
      actual = Order.where(time: tod).first
      assert_equal expected, actual
    end
  end
end
