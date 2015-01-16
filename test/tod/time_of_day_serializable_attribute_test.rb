require File.expand_path(File.join(File.dirname(__FILE__),'..','test_helper'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','support/active_record'))

class Order < ActiveRecord::Base
  serialize :time, Tod::TimeOfDay
end
class TimeOfDayWithActiveRecordSerializableAttribute < Test::Unit::TestCase
  context "self.dump" do
    should "be able to set time of day" do
      Order.create(time: Tod::TimeOfDay.new(9, 30))
    end
    should "be able to set nil as value" do
      Order.create(time: nil)
    end
  end
  context "self.load" do
    should "load set time" do
      time_of_day = Tod::TimeOfDay.new(9, 30)
      order = Order.create(time: time_of_day)
      assert_equal order.time, time_of_day
    end
    should "return nil if time is not set" do
      order = Order.create(time: nil)
      assert_equal order.time, nil
    end
  end
end
