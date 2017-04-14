# 2.1.1 (April 14, 2017)

* Fix serialize Ruby Time to Tod::TimeOfDay (Ryan Dick)
* Fix TimeOfDay.from_second_of_day when passed float (Jack Christensen)
* Fix Rails 5 multi-param assignment (Miklos Fazekas)

# 2.1.0 (May 9, 2016)

* Fix date extensions requiring date (ambirdsall)
* Add subtraction to TimeOfDay (Hiroki Shirai)
* Add equality comparison for shifts (Greg Beech)
* Add arel_extensions for TimeOfDay (Paul Tyng)
* Support for shifts that span to other days (kennyeni)

# 2.0.2 (May 21, 2015)

* Fix ActiveRecord serialization when core extensions not loaded

# 2.0.1 (May 8, 2015)

* Fix Tod::TimeOfDay() without core extensions

# 2.0.0 (April 18, 2015)

* Shift now supports exclusive ends like a Ruby range
* Add Shift#overlaps? (Michael Amor Righi)
* Add Shift#contains? (Michael Amor Righi)
* Do not pollute global namespace

# 1.5.0 (January 15, 2015)

* Fix: return nil unless other is comparable (Peter Yates)
* Parse "noon" as "12pm" and "midnight" as "12am" (Michael Righi)

# 1.4.0 (April 3, 2014)

* Add try_parse (Stuart Olivera)
* Add parse? (Stuart Olivera)

# 1.3.0 (December 9, 2013)

* Add Shift class (Pablo Russo)

# 1.2.2 (November 16, 2013)

* Fix dumping nil or empty string to PostgreSQL time column (Maik Arnold)

# 1.2.1 (September 30, 2013)

* Added DateTime#to_time_of_day (Jonathan Pares)

# 1.2.0 (July 16, 2013)

* Added ActiveRecord TimeOfDay serialization to time column (Maxim-Filimonov)

# 1.1.1 (April 12, 2013)

* Added to_i and from_i as aliases of second_of_day and from_second_of_day (Johnny Shields)

# 1.1.0 (February 13, 2013)

* Added Rails time zone support

# 1.0.0 (December 29, 2010)

* Initial Release
