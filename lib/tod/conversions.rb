module Tod
  def TimeOfDay(obj_or_string)
    if obj_or_string.is_a?(TimeOfDay)
      obj_or_string
    elsif obj_or_string.respond_to?(:to_time_of_day)
      obj_or_string.to_time_of_day
    elsif obj_or_string.respond_to?(:hour) && obj_or_string.respond_to?(:min) && obj_or_string.respond_to?(:sec)
      TimeOfDay.new obj_or_string.hour, obj_or_string.min, obj_or_string.sec
    elsif obj_or_string.is_a?(Date)
      TimeOfDay.new 0
    else
      TimeOfDay.parse(obj_or_string)
    end
  end

  module_function :TimeOfDay
end
