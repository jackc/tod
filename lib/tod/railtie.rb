require "active_model/type"
require "active_record/type"
require "tod/time_of_day_type"

module Tod
  class Railtie < Rails::Railtie
    initializer "tod.register_active_model_type" do
      ActiveModel::Type.register(:time_only, Tod::TimeOfDayType)
      ActiveRecord::Type.register(:time_only, Tod::TimeOfDayType)
    end
  end
end
