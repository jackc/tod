require 'tod/time_of_day'
require 'tod/date'
require 'tod/time'
require 'tod/shift'
require 'tod/conversions'
require 'tod/mongoization'

class Shift < Tod::Shift; end unless defined? Shift

include Tod::Conversions
class TimeOfDay < Tod::TimeOfDay
  include(Tod::Mongoization)
  extend(Tod::Mongoization::ClassMethods)
end
