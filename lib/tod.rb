require 'tod/time_of_day'
require 'tod/core_extensions'
require 'tod/shift'
require 'tod/conversions'
require 'tod/mongoization'

module Tod
  class TimeOfDay
    include(Tod::Mongoization)
    extend(Tod::Mongoization::ClassMethods)
  end
end
