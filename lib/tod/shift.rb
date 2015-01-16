module Tod

  # Shift is a range-like class that handles wrapping around midnight.
  # For example, the Shift of 2300 to 0200 would include 0100.
  class Shift
    attr_reader :beginning, :ending

    def initialize(beginning, ending, exclude_end=false)
      raise ArgumentError, "beginning can not be nil" unless beginning
      raise ArgumentError, "ending can not be nil" unless ending
      unless [true, false].include? exclude_end
        raise ArgumentError, "exclude_end must be true or false"
      end

      @beginning = beginning
      @ending = ending
      @exclude_end = exclude_end

      normalized_ending = ending.to_i
      normalized_ending += TimeOfDay::NUM_SECONDS_IN_DAY if normalized_ending < beginning.to_i

      @range = Range.new(beginning.to_i, normalized_ending, @exclude_end)

      freeze # Shift instances are value objects
    end

    # Returns true if the time of day is inside the shift, false otherwise.
    def include?(tod)
      second = tod.to_i
      second += TimeOfDay::NUM_SECONDS_IN_DAY if second < @range.first
      @range.cover?(second)
    end

    # Return shift duration in seconds.
    # if ending is lower than beginning this method will calculate the duration as the ending time is from the following day
    def duration
      @range.last - @range.first
    end

    def exclude_end?
      @exclude_end
    end
  end
end
