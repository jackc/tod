module Tod
  class Shift
    attr_reader :beginning, :ending

    def initialize(beginning, ending)
      raise ArgumentError, "beginning can not be nil" unless beginning
      raise ArgumentError, "ending can not be nil" unless ending

      @beginning = beginning
      @ending = ending
      freeze # Shift instances are value objects
    end

    # Returns true if the time of day is inside the shift (inclusive range), false otherwise
    def include?(tod)
      if ending >= beginning
        tod >= beginning && tod <= ending
      else
        start_of_day   = TimeOfDay.new(0,0,0)
        end_of_day     = TimeOfDay.new(23,59,59)
        (tod >= beginning && tod <= end_of_day) || (tod >= start_of_day && tod <= ending)
      end
    end

    # Return shift duration in seconds.
    # if ending is lower than beginning this method will calculate the duration as the ending time is from the following day
    def duration
      if ending >= beginning
        (ending.to_i - beginning.to_i)
      else
        start_of_day   = TimeOfDay.new(0,0,0)
        end_of_day     = TimeOfDay.new(23,59,59)
        duration_day_1 = (end_of_day.to_i - beginning.to_i) + 1
        duration_day_2 = (ending.to_i - start_of_day.to_i)
        duration_day_1 + duration_day_2
      end
    end
  end
end

Shift = Tod::Shift
