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

    def inspect
      "#<#{self.class} #{beginning}#{exclude_end? ? '...' : '..'}#{ending}>"
    end

    # Returns true if the time of day is inside the shift, false otherwise.
    def include?(tod)
      second = tod.to_i
      second += TimeOfDay::NUM_SECONDS_IN_DAY if second < @range.first
      @range.cover?(second)
    end

    # Returns true if ranges overlap, false otherwise.
    def overlaps?(other)
      a, b = [self, other].map(&:range)
      #
      #  Although a Shift which passes through midnight is stored
      #  internally as lasting more than TimeOfDay::NUM_SECONDS_IN_DAY
      #  seconds from midnight, that's not how it is meant to be
      #  handled.  Rather, it consists of two chunks:
      #
      #    range.first => Midnight
      #    Midnight => range.last
      #
      #  The second one is *before* the first.  None of it is more than
      #  TimeOfDay::NUM_SECONDS_IN_DAY after midnight.  We thus need to shift
      #  each of our ranges to cover all overlapping possibilities.
      #
      one_day = TimeOfDay::NUM_SECONDS_IN_DAY
      ashifted =
        Range.new(a.first + one_day, a.last + one_day, a.exclude_end?)
      bshifted =
        Range.new(b.first + one_day, b.last + one_day, b.exclude_end?)
      #
      #  For exclusive ranges we need:
      #
      #  a.ending > b.beginning && b.ending > a.beginning
      #
      #  and for inclusive we need:
      #
      #  a.ending >= b.beginning && b.ending >= a.beginning
      #
      aop = a.exclude_end? ? :> : :>=
      bop = b.exclude_end? ? :> : :>=
      #
      (a.last.send(aop, b.first) && b.last.send(bop, a.first)) ||
      (ashifted.last.send(aop, b.first) && b.last.send(bop, ashifted.first)) ||
      (a.last.send(aop, bshifted.first) && bshifted.last.send(bop, a.first))
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
