module Tod
  module Conversions
    module_function

    def TimeOfDay(obj_or_string)
      if obj_or_string.is_a?(TimeOfDay)
        obj_or_string
      elsif obj_or_string.respond_to?(:to_time_of_day)
        obj_or_string.to_time_of_day
      else
        TimeOfDay.parse(obj_or_string)
      end
    end
  end
end
