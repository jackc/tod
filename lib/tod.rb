require 'tod/time_of_day'
require 'tod/date'
require 'tod/time'
require 'tod/shift'
require 'tod/conversions'
require 'tod/mongoization'

include Tod
include Tod::Conversions
class TimeOfDay
  include(Tod::Mongoization)
  extend(Tod::Mongoization::ClassMethods)
end