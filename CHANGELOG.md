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
