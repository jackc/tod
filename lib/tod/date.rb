class Date
  # Returns a local or timezone Time instance with this date and time_of_day
  def at(time_of_day, timezone=nil)
    Time.use_zone timezone do
      Time.zone.local(date.year, date.month, date.day, time_of_day.hour, time_of_day.minute, time_of_day.second)
    end
  end
end
