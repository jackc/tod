module Tod
  module Mongoization

    # Converts an object of this instance into a database friendly value.
    def mongoize
      to_s
    end

    module ClassMethods

      # Get the object as it was stored in the database, and instantiate
      # this custom class from it.
      def demongoize(object)
        Tod::TimeOfDay.parse(object) if object
      end

      # Takes any possible object and converts it to how it would be
      # stored in the database.
      def mongoize(object)
        case object
        when TimeOfDay then object.mongoize
        else object
        end
      end

      # Converts the object that was supplied to a criteria and converts it
      # into a database friendly form.
      def evolve(object)
        case object
        when TimeOfDay then object.mongoize
        else object
        end
      end
    end
  end
end