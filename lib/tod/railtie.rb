require "tod/time_of_day_type"

module Tod
  class Railtie < Rails::Railtie
    initializer "tod.register_active_record_type" do
      ActiveRecord::Type.register(:time_only, Tod::TimeOfDayType)
    end
  end
end
