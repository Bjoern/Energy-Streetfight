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

def read_csv_fixture(fixture_file)
    table_name = File.basename(fixture_file, '.csv')

    if table_empty?(table_name)
	truncate_table(table_name)
	Fixtures.create_fixtures(File.join('db/', 'seeds'), table_name)
    end
end

def read_csv_fixtures
    ["games.csv", "ships.csv","islands.csv", "resources.csv", "problems.csv"].each do |filename|
	File.open("db/seeds/#{filename}") do |fixture_file|
	    #Dir.glob(File.join(RAILS_ROOT, 'db', 'seeds', '*.csv')).each do |fixture_file|
	    read_csv_fixture(fixture_file)
	end
    end
end


puts "now for the users"

def import_users
    File.open("db/seeds/users.csv") do |file|
	file.each_line do |line|
	    data = line.strip.split(";")
	    id = data[0]
	    code = data[-1]
	    ship_id = code[0..-6]

	    puts "data: #{data},  id: #{id}, code: #{code} ship_id: #{ship_id}"

	    user = User.new()
	    user.password = "esf"
	    user.code = code
	    user.ship_id = ship_id
	    user.id = id.to_i
	    #user.save

	    puts "user saved: #{user.save}"
	end
    end
end

#User.new({:name => "Gandalf", :password => "lullaby", :ship_id => 1}).save
def import_map
    File.open("db/seeds/map.csv") do |file|
	file.gets #skip header

	file.each_line do |line|
	    cells = line.split(",",-1)
	    cells.each_with_index do |cell, column|
		cell.strip!
		if cell.size > 0 
		    #puts "#{column}, #{file.lineno}, |#{cell}|, size: #{cell.size}" 
		    cell = cell[1..-2]
		    data = cell.split("/")
		    type = data[0]
		    if type[0] == "i"
			#island
			id = type [1..-1].to_i
			problem = data[1]

			if islands.find(id)
			    raise "error, duplicate island id #{id}"
			end

			island = Island.new(:x => column, :y => file.lineno)
			island.id = id

			problem_type = ProblemType.find_or_create_by_name(problem)

			island.problem = Problem.new(:problem_type => problem_type)

			if data[2]
			    #resource
			    island.resource = Resource.find_by_name(data[2])

			end

			island.save
		    else
			raise "error: unknown map tile type: #{type}"
		    end
		end
	    end
	end
    end
end

read_csv_fixtures
import_users
