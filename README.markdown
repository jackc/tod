Tod
===

Supplies TimeOfDay class that includes parsing, strftime, comparison, and
arithmetic.

Supplies Shift to represent a period of time, using a beginning and ending TimeOfDay. Allows to calculate its duration and
to determine if a TimeOfDay is included inside the shift. For nightly shifts (when beginning time is greater than ending time),
it supposes the shift ends the following day.

Installation
============

    gem install tod

Examples
========

Loading Tod
-----------

    require 'tod'

Creating from hour, minute, and second
--------------------------------------

    Tod::TimeOfDay.new 8                                # => 08:00:00
    Tod::TimeOfDay.new 8, 15, 30                        # => 08:15:30

Parsing text
------------

Strings only need to contain an hour. Minutes, seconds, AM or PM, and colons
are all optional.

    Tod::TimeOfDay.parse "8"                            # => 08:00:00
    Tod::TimeOfDay.parse "8am"                          # => 08:00:00
    Tod::TimeOfDay.parse "8pm"                          # => 20:00:00
    Tod::TimeOfDay.parse "8p"                           # => 20:00:00
    Tod::TimeOfDay.parse "9:30"                         # => 09:30:00
    Tod::TimeOfDay.parse "15:30"                        # => 15:30:00
    Tod::TimeOfDay.parse "3:30pm"                       # => 15:30:00
    Tod::TimeOfDay.parse "1230"                         # => 12:30:00
    Tod::TimeOfDay.parse "3:25:58"                      # => 03:25:58
    Tod::TimeOfDay.parse "515p"                         # => 17:15:00
    Tod::TimeOfDay.parse "151253"                       # => 15:12:53
    Tod::TimeOfDay.parse "noon"                         # => 12:00:00
    Tod::TimeOfDay.parse "midnight"                     # => 00:00:00

Tod::TimeOfDay.parse raises an ArgumentError if the argument to parse is not
parsable. Tod::TimeOfDay.try_parse will instead return nil if the argument is not
parsable.

    Tod::TimeOfDay.try_parse "3:30pm"                   # => 15:30:00
    Tod::TimeOfDay.try_parse "foo"                      # => nil

You can also give a block to parse to handle special input with your own logic.

    Tod::TimeOfDay.parse "25" do |time_string|
      Tod::TimeOfDay.new(time_string.to_i % 24)
    end                                                 # => 01:00:00

Values can be tested with Tod::TimeOfDay.parsable? to see if they can be parsed.

    Tod::TimeOfDay.parsable? "3:30pm"                   # => true
    Tod::TimeOfDay.parsable? "foo"                      # => false

Adding or subtracting time
-----------------------------

Seconds can be added to or subtracted from Tod::TimeOfDay objects. Time correctly wraps
around midnight.

    Tod::TimeOfDay.new(8) + 3600                        # => 09:00:00
    Tod::TimeOfDay.new(8) - 3600                        # => 07:00:00
    Tod::TimeOfDay.new(0) - 30                          # => 23:59:30
    Tod::TimeOfDay.new(23,59,45) + 30                   # => 00:00:15

Comparing
--------------------

Tod::TimeOfDay includes Comparable.

    Tod::TimeOfDay.new(8) < Tod::TimeOfDay.new(9)            # => true
    Tod::TimeOfDay.new(8) == Tod::TimeOfDay.new(9)           # => false
    Tod::TimeOfDay.new(9) == Tod::TimeOfDay.new(9)           # => true
    Tod::TimeOfDay.new(10) > Tod::TimeOfDay.new(9)           # => true

Formatting
----------

Format strings are passed to Time#strftime.

    Tod::TimeOfDay.new(8,30).strftime("%H:%M")          # => "08:30"
    Tod::TimeOfDay.new(17,15).strftime("%I:%M %p")      # => "05:15 PM"
    Tod::TimeOfDay.new(22,5,15).strftime("%I:%M:%S %p") # => "10:05:15 PM"

Or a Rails style `to_formatted_s` is aliased to `to_s`.

    Tod::TimeOfDay.new(8,30).to_s(:short)    # => "8:30 am"

Or [i18n](https://github.com/svenfuchs/i18n) in a Rails ERB view.

    <%= l Tod::TimeOfDay.new(8, 30), format: :short %>

Add new formatters to `Tod::TimeOfDay::FORMATS`.

    Tod::TimeOfDay::FORMATS[:seconds_only] = "%S"
    Tod::TimeOfDay.new(8,30,57).to_s(:seconds_only)  # => "57"

Rounding
----------

Round to the given nearest number of seconds.

    Tod::TimeOfDay.new(8,15,31).round(5)     # => "08:15:30"
    Tod::TimeOfDay.new(8,15,34).round(60)    # => "08:16:00"
    Tod::TimeOfDay.new(8,02,29).round(300)   # => "08:00:00"

Convenience methods for dates and times
---------------------------------------

Pass a date to Tod::TimeOfDay#on and it will return a time with that date and time,
in the time zone of the ruby runtime (`Time.now.zone`).

    tod = Tod::TimeOfDay.new 8, 30                  # => 08:30:00
    tod.on Date.today                               # => 2010-12-29 08:30:00 -0600

Tod offers Date#at and Time#to_time_of_day. Require 'tod/core_extensions' to enable.

    require 'tod/core_extensions'
    tod = Tod::TimeOfDay.new 8, 30                  # => 08:30:00
    Date.today.at tod                               # => 2010-12-29 08:30:00 -0600
    Time.now.to_time_of_day                         # => 16:30:43
    DateTime.now.to_time_of_day                     # => 16:30:43

Conversion method
-----------------

Tod provides a conversion method which will handle a variety of input types:

    Tod::TimeOfDay(Tod::TimeOfDay.new(8, 30))           # => 08:30:00
    Tod::TimeOfDay("09:45")                        # => 09:45:00
    Tod::TimeOfDay(Time.new(2014, 1, 1, 12, 30))   # => 12:30:00
    Tod::TimeOfDay(Date.new(2014, 1, 1))           # => 00:00:00


Shifts
=======================

Tod::Shift is a range-like object that represents a period of time, using a
beginning and ending Tod::TimeOfDay. Allows to calculate its duration and to
determine if a Tod::TimeOfDay is included inside the shift. For nightly shifts
(when beginning time is greater than ending time), it supposes the shift ends
the following day. Tod::Shift behaves like a Ruby range in that it defaults to
inclusive endings. For exclusive endings, pass true as the third argument
(like a Ruby range).

Creating from Tod::TimeOfDay
--------------------------------------

    Tod::Shift.new(Tod::TimeOfDay.new(9), Tod::TimeOfDay.new(17))
    Tod::Shift.new(Tod::TimeOfDay.new(22), Tod::TimeOfDay.new(4))

Duration
--------------------

    Tod::Shift.new(Tod::TimeOfDay.new(9), Tod::TimeOfDay.new(17)).duration # => 28800
    Tod::Shift.new(Tod::TimeOfDay.new(20), Tod::TimeOfDay.new(2)).duration # => 21600

Include?
--------------------

    Tod::Shift.new(Tod::TimeOfDay.new(9), Tod::TimeOfDay.new(17)).include?(Tod::TimeOfDay.new(12)) # => true
    Tod::Shift.new(Tod::TimeOfDay.new(9), Tod::TimeOfDay.new(17)).include?(Tod::TimeOfDay.new(7))  # => false
    Tod::Shift.new(Tod::TimeOfDay.new(20), Tod::TimeOfDay.new(4)).include?(Tod::TimeOfDay.new(2))  # => true
    Tod::Shift.new(Tod::TimeOfDay.new(20), Tod::TimeOfDay.new(4)).include?(Tod::TimeOfDay.new(18)) # => false

#include? respects exclusive endings.

    Tod::Shift.new(Tod::TimeOfDay.new(5), Tod::TimeOfDay.new(9)).include?(Tod::TimeOfDay.new(9)) # => true
    Tod::Shift.new(Tod::TimeOfDay.new(5), Tod::TimeOfDay.new(9), true).include?(Tod::TimeOfDay.new(9)) # => false


Overlaps?
--------------------

    breakfast = Tod::Shift.new(Tod::TimeOfDay.new(8), Tod::TimeOfDay.new(11))
    lunch = Tod::Shift.new(Tod::TimeOfDay.new(10), Tod::TimeOfDay.new(14))
    breakfast.overlaps?(lunch) # => true
    lunch.overlaps?(breakfast) # => true

    dinner = Tod::Shift.new(Tod::TimeOfDay.new(18), Tod::TimeOfDay.new(20))
    dinner.overlaps?(lunch) # => false

    # Exclude ending
    morning_shift = Tod::Shift.new(Tod::TimeOfDay.new(9), Tod::TimeOfDay.new(17), true)
    evening_shift = Tod::Shift.new(Tod::TimeOfDay.new(17), Tod::TimeOfDay.new(1), true)
    morning_shift.overlaps?(evening_shift) # => false


Contains?
--------------------
    workday = Shift.new(TimeOfDay.new(9), TimeOfDay.new(17))
    lunch = Shift.new(TimeOfDay.new(10), TimeOfDay.new(14))
    workday.contains?(lunch) # => true
    lunch.contains?(workday) # => false

    dinner = Shift.new(TimeOfDay.new(18), TimeOfDay.new(20))
    dinner.overlaps?(lunch) # => false


Rails Time Zone Support
=======================

If Rails time zone support is loaded, Date#on and Tod::TimeOfDay#at (when given a Date) will automatically use Time.zone.

When Tod::TimeOfDay#on is given a `Time` or `Time`-like object like `ActiveSupport::TimeWithZone`,
Tod will ignore the specified timezone and return the time on that date in UTC. In order to
produce an object with the correct time and time zone, pass in an
`ActiveSupport::TimeZone` object. Date#at has analogous behavior.

    time = Time.now.in_time_zone("US/Eastern")           # => Mon, 24 Sep 2018 05:07:23 EDT -04:00
    tod.on time                                          # => Mon, 24 Sep 2018 08:30:00 UTC +00:00
    tod.on time, time.time_zone                          # => Mon, 24 Sep 2018 08:30:00 EDT -04:00
    tod.on time, Time.find_zone!("US/Mountain")          # => Mon, 24 Sep 2018 08:30:00 MDT -06:00
    Date.tomorrow.at tod, Time.find_zone!("US/Mountain") # => Tue, 25 Sep 2018 08:30:00 MDT -06:00

ActiveRecord Attribute Support
=======================
Tod::TimeOfDay can be used as an ActiveRecord attribute to store Tod::TimeOfDay directly
in a column of the time type.

Example:

```ruby
ActiveModel::Type.register(:time_only, Tod::TimeOfDayType)
ActiveRecord::Type.register(:time_only, Tod::TimeOfDayType)

class Order < ActiveRecord::Base
  attribute :time, :time_only
end
order = Order.create(time: Tod::TimeOfDay.new(9,30))
order.time                                      # => 09:30:00
```

In Rails, this can be used with `time_select` in forms like so:

```ruby
f.time_select :time, ignore_date: true
```

Or with **simple_form**:

```ruby
f.input :time, as: :time, ignore_date: true
```

MongoDB Support
===============

Tod includes optional serialization support for Tod::TimeOfDay to be serialized to MongoDB.

```
require 'tod/mongoization'
```

Upgrading from Versions Prior to 2.0.0
======================================

Tod has a new focus on not polluting the global namespace.

Tod no longer puts Tod::TimeOfDay and Tod::Shift in the global namespace by default. You can either fully qualify access to these classes or include Tod in the global namespace.

```
require 'tod'
include Tod # TimeOfDay and Shift are now in the global namespace like in versions prior to 2.0.0
```

Tod no longer automatically extends the Time and Date classes. Require them explicitly.

```
require 'tod/core_extensions'
tod = Tod::TimeOfDay.new 8, 30                  # => 08:30:00
Date.today.at tod                               # => 2010-12-29 08:30:00 -0600
Time.now.to_time_of_day                         # => 16:30:43
DateTime.now.to_time_of_day                     # => 16:30:43
```

Tod no longer automatically includes MongoDB serialization methods in Tod::TimeOfDay. Require them explicitly.

```
require 'tod/mongoization'
```

Compatibility
=============

[![Build Status](https://travis-ci.org/jackc/tod.png)](https://travis-ci.org/jackc/tod)

Tod is tested against Ruby 2.6.x and  Rails 6.x.


License
=======

Copyright (c) 2010-2021 Jack Christensen, released under the MIT license
