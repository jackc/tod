module Tod
  module Quoting
    def quote(value, *args)
      # RTTI makes this super rigid; sadly, when in Rome....
      value.kind_of?(Tod::TimeOfDay) ? super(value.to_s, *args) : super
    end
  end
end

