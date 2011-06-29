class Game < ActiveRecord::Base
    attr_accessible :turn, :is_updating

    has_many :ships
    has_many :islands
    has_many :problems
    has_many :resources
    has_many :users    

    def self.update(id)
	g = Game.find(id)

	g.is_updating = true

	g.save!

	puts "updating game to turn #{g.turn+1}"

	begin
	    islands_map = {}
	    problem_free_islands = []

	    g.islands.each do |island|
		#puts "mapping island #{island.id}"
		islands_map[island.id] = island
		if not island.problem
		    problem_free_islands << island
		end
	    end

	    #group by island and sort by speed => fastest boat solves island problem first
	    ships = Game.sort_ships_by_time_to_destination(g.ships)

	    Game.transaction do
		ships.each do |ship|

		    puts "processing ship #{ship.name}, id #{ship.id}, speed: #{ship.speed}"
		    #puts "processing ship #{ship.id}"
		    destination = ship.destination_id ? islands_map[ship.destination_id] : nil

		    votes_summary = Vote.summary(ship.id, g.turn)

		    if destination and ship.harbor_id == ship.destination_id # Game.is_ship_on_island(ship, destination)

			#ship.harbor = destination #ship has landed
			puts "ship #{ship.name} is on island #{destination.name}, deciding actions"
			total = votes_summary[:total]
			is_unload = votes_summary[:unload_votes] >= total/2.0 #TODO stalemate resolution
			is_load = votes_summary[:load_votes] >= total/2.0

			if(is_unload and ship.resource)
			    Game.unload_resource(ship, destination, problem_free_islands) #TODO several ships arriving at the same time with same speed?
			end

			if(is_load and not ship.resource)
			    #load
			    ship.resource = destination.resource
			    puts "#{ship.name} has loaded #{destination.resource ? destination.resource.name : 'nothing'}"
			end
		    #else
		#	ship.destination = nil #ship is at sea
		    end

		    #determine new destination
		    new_destination_id = nil
		    destination_votes = 0

		    votes_summary[:destinations].each do |dest_id, votes|
			if (not new_destination_id) or votes > destination_votes
			    new_destination_id = dest_id
			end
		    end

		    if new_destination_id
			ship.destination = islands_map[new_destination_id]
			puts "new destination: #{ship.destination}, id: #{new_destination_id}"
			puts "ship #{ship.name} set sail for island #{ship.destination.name}"
		    end

		end

		#update positions before speed - new speed will only apply in the coming rounds
		Game.update_positions(ships)

		#update speeds
		if g.turn % 3 == 1 #g.next_meter_reading_turn
		    Game.update_speeds(ships, g.turn == 1)		
		end	

		ships.each do |ship|
		    ship.save
		end

		puts "islands and ships processed, update turn number #{g.turn}"

		new_turn = 1+g.turn

		g.turn = new_turn 
		puts "turn after update: #{g.turn}"


		puts "save result #{g.save!}"

		#raise "whatever"
	    end

	ensure
	    g.is_updating = false
	    puts "ensuring"
	    is_saved = g.save

	    puts "is_saved #{is_saved}"
	end
	puts "turn at the end: #{g.turn} new load #{Game.first.turn}"
    end

    def self.update_positions(ships)
	ships.each do |ship|
	    destination = ship.destination
	    speed = ship.speed
	    if(destination and speed > 0)
		distance = Game.distance(ship.x, ship.y, destination.x, destination.y) #distance to center of island
#		speed = [distance - destination.diameter, speed].min #don't sail through island

		distance_to_border = Game.distance_to_island(ship, destination)
		if  distance_to_border <= ship.speed
		    speed = distance_to_border
		    ship.harbor = destination #ship arrived on island
		    puts "ship #{ship.name} has arrived on #{destination.name}"
		else
		    ship.harbor = nil #ship is still at sea
		end

		factor = distance > 0 ? speed/distance : 0

		puts "ship #{ship.name} x: #{ship.x}, y: #{ship.y}, distance: #{distance}, speed: #{speed}, dest.x #{destination.x}, dest.y #{destination.y}, radius #{destination.diameter/2}"

		ship.x += (destination.x - ship.x)*factor
		ship.y += (destination.y - ship.y)*factor

		puts "ship #{ship.name} moved to x: #{ship.x}, y: #{ship.y}"

	    end
	end
    end

#> - when are meter readings submitted?
#
#One round out of three the meter readings are submitted. This happens each Monday evening, before midnight.  The other votes are due on Wednesday before midnight and Friday before midnight. Does this answer your third question, too?
#
#> - how is speed calculated from meter readings?
#EC(n) = EnergyConsumption for week n for considered house
#MR(n) = MeterReading for week n
#ECmax(n) = Highest energy consumption among all houses on week n
#ECmin(n) = Lowest energy consumption among all houses on week n
#
#ECn = MR(n) - MR(n-1)
#
#Speed(n) = SpeedMin + ((EC(n) - ECmin(n))/(ECmax(n) - ECmin(n)))*(SpeedMax - SpeedMin)
#
    def self.update_speeds(ships, is_first_turn)
	#get average consumption for each crew mate
	# => EC(n)

	puts "updating speeds"

	min_consumption = 0
	max_consumption = nil

	min_speed = 15 #constants
	max_speed = 30 #

	ships.each do |ship|
	    total_consumption = 0
	    total_users = 0 
	    ship.users.each do |user|
		if user.last_reading
		    puts "user #{user.id} has last reading #{user.last_reading.reading}"
		    if user.previous_reading
			consumption = user.last_reading.reading - user.previous_reading.reading
			turns = user.last_reading.turn - user.previous_reading.turn

			puts "user consumption: #{consumption}, turns: #{turns}"

			if turns > 0 and consumption > 0
			    consumption = consumption/turns
			    total_consumption += consumption
			    total_users += 1
			    puts "user #{user.id} has consumption #{consumption}"
			end	
		    else
			puts "no previous_reading"
		    end
		    user.previous_reading = user.last_reading
		    user.last_reading = nil
		    user.save
		end
	    end

	    #only create new speed if at least one user entered a meter reading
	    if total_users > 0 and not is_first_turn
		ship.consumption = total_consumption
		if ship.consumption < min_consumption
		    min_consumption = ship.consumption
		end

		if (not max_consumption) or (ship.consumption > max_consumption)
		    max_consumption = ship.consumption
		end 
		puts "ship #{ship.name} has consumption #{ship.consumption}"
	    else
		puts "ship #{ship.name} has zero consumption"
		ship_consumption = nil
	    end
	end

	ships_count = 0

	if max_consumption and max_consumption - min_consumption > 0
	    ships.each do |ship|
		#update speeds
		if ship.consumption 
		    ship.speed = min_speed + ((ship.consumption - min_consumption)/(max_consumption - min_consumption))*(max_speed - min_speed)

		    puts "updated speed of ship #{ship.id} to #{ship.speed}"

		    ships_count += 1
		else
		    ship.speed = 0 if not is_first_turn
		end	    
	    end
	end
    end

    def self.unload_resource(ship, island, problem_free_islands)

	puts "ship #{ship.name} unloads #{ship.resource.name} on #{island.name}"

	if island.problem and ship.resource = island.problem.resource
	    #solve it
	    ship.problems_solved += 1
	    problem = island.problem
	    island.problem = nil
	    island.save

	    #puts "ship #{ship.name} solved #{problem.name} on #{island.name}"

	    problem_free_islands << island
	    #find new island for problem

	    if problem_free_islands.size > 0
		island_index = Random.rand(problem_free_islands.size)
		new_island = problem_free_islands.slice!(island_index)
		new_island.problem = problem
		new_island.save
		puts "problem #{problem.name} solved on island #{island.name} by ship #{ship.name}. New island is #{new_island.name}"
	    else
		puts "error: no island without problems found, could not reditribute problem"
	    end
	end

	ship.resource = nil
    end

    def self.is_ship_on_island(ship, island)
	Game.distance(ship.x, ship.y, island.x, island.y) <= island.diameter * 1.05 #5% uncertainty	
    end

    def self.distance(x1,y1,x2,y2)
	Math.hypot(x1-x2,y1-y2)
    end

    def self.distance_to_island(ship, island)
	Math.hypot(ship.x-island.x, ship.y-island.y)-island.diameter/2
    end

   # def after_commit
	#puts "committed"
    #end


    #only one reading every three turns
    def next_meter_reading_turn
	1+((turn+1)/3)*3
    end

    def self.sort_ships_by_time_to_destination(ships)
	ships.sort do |a,b|
	    time_a = a.destination ? Game.distance_to_island(a, a.destination)/a.speed : 0
	    time_b = b.destination ? Game.distance_to_island(b, b.destination)/b.speed : 0

	    time_a <=> time_b
	end
    end

end
