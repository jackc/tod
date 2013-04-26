Tod
===

Supplies TimeOfDay class that includes parsing, strftime, comparison, and
arithmetic.


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

    TimeOfDay.new 8                                # => 08:00:00
    TimeOfDay.new 8, 15, 30                        # => 08:15:30

Parsing text
------------

Strings only need to contain an hour. Minutes, seconds, AM or PM, and colons
are all optional.

    TimeOfDay.parse "8"                            # => 08:00:00
    TimeOfDay.parse "8am"                          # => 08:00:00
    TimeOfDay.parse "8pm"                          # => 20:00:00
    TimeOfDay.parse "8p"                           # => 20:00:00
    TimeOfDay.parse "9:30"                         # => 09:30:00
    TimeOfDay.parse "15:30"                        # => 15:30:00
    TimeOfDay.parse "3:30pm"                       # => 15:30:00
    TimeOfDay.parse "1230"                         # => 12:30:00
    TimeOfDay.parse "3:25:58"                      # => 03:25:58
    TimeOfDay.parse "515p"                         # => 17:15:00
    TimeOfDay.parse "151253"                       # => 15:12:53

Adding or subtracting time
-----------------------------

Seconds can be added to or subtracted TimeOfDay objects. Time correctly wraps
around midnight.

    TimeOfDay.new(8) + 3600                        # => 09:00:00
    TimeOfDay.new(8) - 3600                        # => 07:00:00
    TimeOfDay.new(0) - 30                          # => 23:59:30
    TimeOfDay.new(23,59,45) + 30                   # => 00:00:15

Comparing
--------------------

TimeOfDay includes Comparable.

    TimeOfDay.new(8) < TimeOfDay.new(9)            # => true
    TimeOfDay.new(8) == TimeOfDay.new(9)           # => false
    TimeOfDay.new(9) == TimeOfDay.new(9)           # => true
    TimeOfDay.new(10) > TimeOfDay.new(9)           # => true

Formatting
----------

Format strings are passed to Time#strftime.

    TimeOfDay.new(8,30).strftime("%H:%M")          # => "08:30"
    TimeOfDay.new(17,15).strftime("%I:%M %p")      # => "05:15 PM"
    TimeOfDay.new(22,5,15).strftime("%I:%M:%S %p") # => "10:05:15 PM"

Convenience methods for dates and times
---------------------------------------

Tod adds Date#on and Time#to_time_of_day. If you do not want the core extensions
then require 'tod/time_of_day' instead of 'tod'.

    tod = TimeOfDay.new 8, 30                       # => 08:30:00
    tod.on Date.today                               # => 2010-12-29 08:30:00 -0600
    Date.today.at tod                               # => 2010-12-29 08:30:00 -0600
    Time.now.to_time_of_day                         # => 16:30:43

Rails Time Zone Support
=======================

If Rails time zone support is loaded, Date#on and TimeOfDay#at will automatically use Time.zone.

Compatibility
=============

[![Build Status](https://travis-ci.org/JackC/tod.png)](https://travis-ci.org/JackC/tod)

Tod is compatible with Ruby 1.9.3 and 2.0.0 and Rails 3.0, 3.1, 3.2, and 4.0.


History
=======

## 1.1.1 (April 12, 2013)

* Added to_i and from_i as aliases of second_of_day and from_second_of_day (Johnny Shields)

## 1.1.0 (February 13, 2013)

* Added Rails time zone support

## 1.0.0 (December 29, 2010)

* Initial Release

License
=======

Copyright (c) 2010-2013 Jack Christensen, released under the MIT license
