module Tod
  class TimeOfDayType < ActiveModel::Type::Value
    def cast(value)
      if value.is_a? Hash
          # rails multiparam attribute
          # get hour, minute and second and construct new TimeOfDay object
        ::Tod::TimeOfDay.new(value[4], value[5], value[6] || 0)
      else
        # return nil, if input is not parsable
        Tod::TimeOfDay(value){}
      end
    end

    def serialize(value)
      value.to_s if value.present?
    end
  end
end
