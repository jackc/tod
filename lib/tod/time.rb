class Time
  def to_time_of_day
    TimeOfDay.new hour, min, sec
  end
end
