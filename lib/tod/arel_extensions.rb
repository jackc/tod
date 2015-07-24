require 'arel'

module Tod
  module ArelDepthFirstExtensions
    def self.included(base)
      base.send :alias_method, :visit_Tod_TimeOfDay, :terminal
    end
  end

  module ArelDotExtensions
    def self.included(base)
      base.send :alias_method, :visit_Tod_TimeOfDay, :visit_String
    end
  end

  module ArelToSqlExtensions
    def visit_Tod_TimeOfDay(o, collector=nil)
      quote Tod::TimeOfDay.dump(o)
    end
  end
end

Arel::Visitors::DepthFirst.send :include, Tod::ArelDepthFirstExtensions
Arel::Visitors::Dot.send :include, Tod::ArelDotExtensions
Arel::Visitors::ToSql.send :include, Tod::ArelToSqlExtensions
