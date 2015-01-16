class Time
  def to_time_of_day
    Tod::TimeOfDay.new hour, min, sec
  end
end
