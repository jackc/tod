module Tod
  class TimeOfDay
    include Comparable

    attr_reader :hour, :minute, :second, :second_of_day
    alias_method :min, :minute
    alias_method :sec, :second

    PARSE_24H_REGEX = /
      \A
      ([01]?\d|2[0-3])
      :?
      ([0-5]\d)?
      :?
      ([0-5]\d)?
      \z
    /x

    PARSE_12H_REGEX = /
      \A
      (0?\d|1[0-2])
      :?
      ([0-5]\d)?
      :?
      ([0-5]\d)?
      \s*
      ([ap])
      \.?
      \s*
      m?
      \.?
      \z
    /x

    NUM_SECONDS_IN_DAY = 86400
    NUM_SECONDS_IN_HOUR = 3600
    NUM_SECONDS_IN_MINUTE = 60

    def initialize(h, m=0, s=0)
      @hour = Integer(h)
      @minute = Integer(m)
      @second = Integer(s)

      raise ArgumentError, "hour must be between 0 and 23" unless (0..23).include?(@hour)
      raise ArgumentError, "minute must be between 0 and 59" unless (0..59).include?(@minute)
      raise ArgumentError, "second must be between 0 and 59" unless (0..59).include?(@second)

      @second_of_day = @hour * 60 * 60 + @minute * 60 + @second
    end

    def <=>(other)
      @second_of_day <=> other.second_of_day
    end

    def strftime(format_string)
      Time.local(2000,1,1, @hour, @minute, @second).strftime(format_string)
    end

    def to_s
      strftime "%H:%M:%S"
    end

    def +(num_seconds)
      TimeOfDay.from_second_of_day @second_of_day + num_seconds
    end

    def -(num_seconds)
      TimeOfDay.from_second_of_day @second_of_day - num_seconds
    end

    def on(date)
      Time.local date.year, date.month, date.day, @hour, @minute, @second
    end

    def self.from_second_of_day(second_of_day)
      remaining_seconds = second_of_day % NUM_SECONDS_IN_DAY
      hour = remaining_seconds / NUM_SECONDS_IN_HOUR
      remaining_seconds -= hour * NUM_SECONDS_IN_HOUR
      minute = remaining_seconds / NUM_SECONDS_IN_MINUTE
      remaining_seconds -= minute * NUM_SECONDS_IN_MINUTE
      new hour, minute, remaining_seconds
    end

    def self.parse(tod_string)
      tod_string = tod_string.strip
      tod_string = tod_string.downcase
      if PARSE_24H_REGEX =~ tod_string || PARSE_12H_REGEX =~ tod_string
        hour, minute, second, a_or_p = $1.to_i, $2.to_i, $3.to_i, $4
        if hour == 12 && a_or_p == "a"
          hour = 0
        elsif hour < 12 && a_or_p == "p"
          hour += 12
        end

        new hour, minute, second
      else
        raise ArgumentError, "Invalid time of day string"
      end
    end
  end
end

TimeOfDay = Tod::TimeOfDay
