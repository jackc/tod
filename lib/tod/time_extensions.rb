module Tod
  module TimeExtensions
    def to_time_of_day
      Tod::TimeOfDay.new hour, min, sec
    end
  end
end

Time.send :include, Tod::TimeExtensions
