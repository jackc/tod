require 'date'

module Tod
  module DateExtensions
    # Returns a local Time instance with this date and time_of_day
    # Pass in time_zone to use ActiveSupport::TimeZone
    def at(time_of_day, time_zone=Tod::TimeOfDay.time_zone)
      time_zone.local year, month, day, time_of_day.hour, time_of_day.minute, time_of_day.second
    end

    def to_time_of_day
      Tod::TimeOfDay.new hour, minute, second
    end
  end
end

Date.send :include, Tod::DateExtensions
