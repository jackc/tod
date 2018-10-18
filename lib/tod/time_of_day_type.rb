module Tod
  class TimeOfDayType < ActiveModel::Type::Value
    def cast(value)
      TimeOfDay.load(value)
    end

    def serialize(value)
      TimeOfDay.dump(value)
    end
  end
end
