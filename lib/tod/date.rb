class Date
  def at(time_of_day)
    Time.local year, month, day, time_of_day.hour, time_of_day.minute, time_of_day.second
  end
end
