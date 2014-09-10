module Tod
  class TimeOfDay
    include Comparable

    attr_reader :hour, :minute, :second, :second_of_day
    alias_method :min, :minute
    alias_method :sec, :second
    alias_method :to_i, :second_of_day

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

    WORDS = {
      "noon" => "12pm",
      "midnight" => "12am"
    }

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

      freeze # TimeOfDay instances are value objects
    end

    def <=>(other)
      @second_of_day <=> other.second_of_day
    end

    # Formats identically to Time#strftime
    def strftime(format_string)
      Time.local(2000,1,1, @hour, @minute, @second).strftime(format_string)
    end

    def to_s
      strftime "%H:%M:%S"
    end

    # Return a new TimeOfDay num_seconds greater than self. It will wrap around
    # at midnight.
    def +(num_seconds)
      TimeOfDay.from_second_of_day @second_of_day + num_seconds
    end

    # Return a new TimeOfDay num_seconds less than self. It will wrap around
    # at midnight.
    def -(num_seconds)
      TimeOfDay.from_second_of_day @second_of_day - num_seconds
    end

    # Returns a Time instance on date using self as the time of day
    # Optional time_zone will build time in that zone
    def on(date, time_zone=Tod::TimeOfDay.time_zone)
      time_zone.local date.year, date.month, date.day, @hour, @minute, @second
    end

    # Build a new TimeOfDay instance from second_of_day
    #
    #   TimeOfDay.from_second_of_day(3600) == TimeOfDay.new(1)   # => true
    def self.from_second_of_day(second_of_day)
      remaining_seconds = second_of_day % NUM_SECONDS_IN_DAY
      hour = remaining_seconds / NUM_SECONDS_IN_HOUR
      remaining_seconds -= hour * NUM_SECONDS_IN_HOUR
      minute = remaining_seconds / NUM_SECONDS_IN_MINUTE
      remaining_seconds -= minute * NUM_SECONDS_IN_MINUTE
      new hour, minute, remaining_seconds
    end
    class << self
      alias :from_i :from_second_of_day
    end

    # Build a TimeOfDay instance from string
    #
    # Strings only need to contain an hour. Minutes, seconds, AM or PM, and colons
    # are all optional.
    #   TimeOfDay.parse "8"                            # => 08:00:00
    #   TimeOfDay.parse "8am"                          # => 08:00:00
    #   TimeOfDay.parse "8pm"                          # => 20:00:00
    #   TimeOfDay.parse "8p"                           # => 20:00:00
    #   TimeOfDay.parse "9:30"                         # => 09:30:00
    #   TimeOfDay.parse "15:30"                        # => 15:30:00
    #   TimeOfDay.parse "3:30pm"                       # => 15:30:00
    #   TimeOfDay.parse "1230"                         # => 12:30:00
    #   TimeOfDay.parse "3:25:58"                      # => 03:25:58
    #   TimeOfDay.parse "515p"                         # => 17:15:00
    #   TimeOfDay.parse "151253"                       # => 15:12:53
    def self.parse(tod_string)
      try_parse(tod_string) || (raise ArgumentError, "Invalid time of day string")
    end

    # Same as parse(), but return nil if not parsable (instead of raising an error)
    #   TimeOfDay.try_parse "8am"                      # => 08:00:00
    #   TimeOfDay.try_parse ""                         # => nil
    #   TimeOfDay.try_parse "abc"                      # => nil
    def self.try_parse(tod_string)
      tod_string = tod_string.to_s
      tod_string = tod_string.strip
      tod_string = tod_string.downcase
      tod_string = WORDS[tod_string] || tod_string
      if PARSE_24H_REGEX =~ tod_string || PARSE_12H_REGEX =~ tod_string
        hour, minute, second, a_or_p = $1.to_i, $2.to_i, $3.to_i, $4
        if hour == 12 && a_or_p == "a"
          hour = 0
        elsif hour < 12 && a_or_p == "p"
          hour += 12
        end

        new hour, minute, second
      else
        nil
      end
    end

    # Determine if a string is parsable into a TimeOfDay instance
    #   TimeOfDay.parsable? "8am"                      # => true
    #   TimeOfDay.parsable? "abc"                      # => false
    def self.parsable?(tod_string)
      !!try_parse(tod_string)
    end

    # If ActiveSupport TimeZone is available and set use current time zone else return Time
    def self.time_zone
      (Time.respond_to?(:zone) && Time.zone) || Time
    end

    def self.dump(time_of_day)
      if time_of_day.to_s == ''
        nil
      else
        time_of_day.to_s
      end
    end

    def self.load(time)
      if time.respond_to?(:to_time_of_day)
        time.to_time_of_day
      else
        TimeOfDay.parse(time) if time && !time.empty?
      end
    end
  end
end