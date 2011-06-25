class Game < ActiveRecord::Base
    attr_accessible :turn, :is_updating

    has_many :ships
    has_many :islands
    has_many :problems
    has_many :resources
    has_many :users    

    def self.update
	g = Game.first

	g.is_updating = true

	g.save!

	puts "updating game to turn #{g.turn}"

	begin
	    islands_map = {}

	    g.islands.each do |island|
		#puts "mapping island #{island.id}"
		islands_map[island.id] = island
	    end

	    #group by island and sort by speed => fastest boat solves island problem first
	    ships = g.ships.sort do |a,b|
		a.destination_id == b.destination_id ? a.speed <=> b.speed : a.destination_id <=> b.destination_id
	    end

	    ships.each do |ship|

		#puts "processing ship #{ship.id}"
		destination = islands_map[ship.destination_id]

		votes_summary = Vote.summary(ship, g.turn)

		if destination and Game.is_ship_on_island(ship, destination)
		    total = votes_summary[:total]
		    is_unload = votes_summary[:unload_votes] >= total/2.0 #TODO stalemate resolution
		    is_load = votes_summary[:load_votes] >= total/2.0

		    if(is_unload and ship.resource)
			Game.unload_resource(ship, destination) #TODO several ships arriving at the same time?
		    end
		end

		#count votes
		#do action
	    end
	    
	    #update speeds
	    if g.turn == g.next_meter_reading_turn
		#get average consumption for each crew mate
		# => EC(n)

		ships.each do |ship|
		    average_consumption = 0


		end
	    end	

	    Game.transaction do

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

    def self.unload_resource(ship, island)
	
    end

    def self.is_ship_on_island(ship, island)
	Game.distance(ship.x, ship.y, island.x, island.y) <= island.diameter	
    end

    def self.distance(x1,y1,x2,y2)
	Math.hypot(x1-x2,y1-y2)
    end

    def after_commit
	puts "committed"
    end


    #only one reading every three turns
    def next_meter_reading_turn
	1+(turn/3)*3
    end

end
