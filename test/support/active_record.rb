require 'active_record'
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Migration.create_table :orders do |t|
  t.time :time
  t.timestamps null: false
end
