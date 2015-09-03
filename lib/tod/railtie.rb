require 'tod/time_of_day'
require 'tod/quoting'

module Tod
  require 'rails'

  class Railtie < Rails::Railtie
    initializer 'tod.add_time_of_day_quoting_to_postgres' do
      ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.instance_eval { include Tod::Quoting }
    end

    # TODO: Initializes for other databases?
  end
end

