require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'tod', 'quoting'))

describe Tod::Quoting do
  before do
    ActiveRecord::ConnectionAdapters::SQLite3Adapter.instance_eval { include Tod::Quoting }
  end

  describe "#quote" do
    it "returns a value the database will understand" do
      time_of_day = Tod::TimeOfDay.new(7, 30)
      quoted_time_of_day = ActiveRecord::Base.connection.quote(time_of_day)
      assert_equal "'#{time_of_day}'", quoted_time_of_day
    end
  end
end

