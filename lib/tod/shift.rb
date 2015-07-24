module Tod

  # Shift is a range-like class that handles wrapping around midnight.
  # For example, the Shift of 2300 to 0200 would include 0100.
  class Shift
    attr_reader :beginning, :ending, :range

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

    # Returns true if ranges overlap, false otherwise.
    def overlaps?(other)
      max_seconds = TimeOfDay::NUM_SECONDS_IN_DAY

      # Standard case, when Shifts are on the same day
      a, b = [self, other].map(&:range).sort_by(&:first)
      op = a.exclude_end? ? :> : :>=
      return true if a.last.send(op, b.first)

      # Special cases, when Shifts span to the next day
      return false if (a.last < max_seconds) && (b.last < max_seconds)

      a = Range.new(a.first, a.last - max_seconds, a.exclude_end?) if a.last > max_seconds
      b = Range.new(b.first, b.last - max_seconds, b.exclude_end?) if b.last > max_seconds
      a, b = [a, b].sort_by(&:last)
      b.last.send(op, a.last) && a.last.send(op, b.first)
    end

    def contains?(shift)
      self.include?(shift.beginning) && self.include?(shift.ending)
    end

    # Return shift duration in seconds.
    # if ending is lower than beginning this method will calculate the duration as the ending time is from the following day
    def duration
      @range.last - @range.first
    end

    def exclude_end?
      @exclude_end
    end

    def ==(other)
      @range == other.range
    end

    def eql?(other)
      @range.eql?(other.range)
    end

    def hash
      @range.hash
    end

    # Move start and end by a number of seconds and return new shift.
    def slide(seconds)
      self.class.new(beginning + seconds, ending + seconds, exclude_end?)
    end
  end
end
