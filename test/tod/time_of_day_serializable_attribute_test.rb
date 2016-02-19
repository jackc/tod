require File.expand_path(File.join(File.dirname(__FILE__),'..','test_helper'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','support/active_record'))

class Order < ActiveRecord::Base
  serialize :time, Tod::TimeOfDay
end

describe "TimeOfDay with ActiveRecord Serializable Attribute" do
  describe ".dump and .load" do
    it "handles normal time" do
      time_of_day = Tod::TimeOfDay.new(9, 30)
      order = Order.create!(time: time_of_day)
      order.reload
      assert_equal order.time, time_of_day
    end

    it "handles nil" do
      order = Order.create!(time: nil)
      order.reload
      assert_equal order.time, nil
    end

    # https://github.com/rails/rails/issues/7125
    it "blocks dumping 24:00:00 before Rails can cause data corruption" do
      time_of_day = Tod::TimeOfDay.new(24, 0, 0)
      assert_raises(Tod::TimeOfDay::ActiveRecordTimeDumpError) do
        Order.new(time: time_of_day)
      end
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
