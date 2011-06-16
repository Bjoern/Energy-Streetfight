# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'active_record/fixtures'

#fixture loading code adapted from http://derekdevries.com/2009/04/13/rails-seed-data/

def table_empty?(table_name)
    quoted = connection.quote_table_name(table_name)
    connection.select_value("SELECT COUNT(*) FROM #{quoted}").to_i.zero?
end

def truncate_table(table_name)
    quoted = connection.quote_table_name(table_name)
    connection.execute("DELETE FROM #{quoted}")
end

def connection
    ActiveRecord::Base.connection
end

def read_csv_fixtures
    Dir.glob(File.join(RAILS_ROOT, 'db', 'seeds', '*.csv')).each do |fixture_file|
	table_name = File.basename(fixture_file, '.csv')

	if table_empty?(table_name)
	    truncate_table(table_name)
	    Fixtures.create_fixtures(File.join('db/', 'seeds'), table_name)
	end
    end
end

puts "now for the user"

User.new({:name => "Gandalf", :password => "lullaby", :ship_id => 1}).save


