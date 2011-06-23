class Game < ActiveRecord::Base
    attr_accessible :turn, :is_updating

    has_many :ships
    has_many :islands
    has_many :problems
    has_many :resources
    has_many :users    


    def update_game
	#game = Game.find(1)

	is_updating = true

	save!

	puts "updating game to turn #{turn}"
    
	begin


	    #ships = game.ships

	    #islands = game.islands

	    islands_map = {}

	    islands.each do |island|
		#puts "mapping island #{island.id}"
		islands_map[island.id] = island
	    end

	    ships.each do |ship|

		#puts "processing ship #{ship.id}"
		destination = islands_map[ship.destination_id]

		votes_summary = Vote.summary(ship, turn)

		if destination and is_ship_on_island(ship, destination)

		end

		#count votes
		#do action
	    end
	    #transaction do

		puts "islands and ships processed, update turn number #{turn}"

		new_turn = 1+turn

		puts "new turn: #{new_turn}"
		turn = new_turn 
		puts "turn after update: #{turn}"

		description = "bla bla"

		puts "save result #{save!}"

		#raise "whatever"
	    #end

	ensure
	    is_updating = false
	    puts "ensuring"
	    self.save!
	end
	puts "turn at the end: #{turn} new load #{Game.first.turn}"

    end

    def is_ship_on_island(ship, island)
	distance(ship.x, ship.y, island.x, island.y) <= island.diameter	
    end

    def distance(x1,y1,x2,y2)
	Math.hypot(x1-x2,y1-y2)
    end

    def after_commit
	puts "committed"
    end

    def after_rollback
	puts "rolled back"
    end

end
