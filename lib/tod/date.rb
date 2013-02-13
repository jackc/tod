class Date
  # Returns a local Time instance with this date and time_of_day
  # Pass in time_zone to use ActiveSupport::TimeZone
  def at(time_of_day, time_zone=Time)
    time_zone.local year, month, day, time_of_day.hour, time_of_day.minute, time_of_day.second
  end
end
