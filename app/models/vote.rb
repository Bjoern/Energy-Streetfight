class Vote < ActiveRecord::Base
    attr_accessible :destination_id, :unload, :load

    belongs_to :ship
    belongs_to :user

    def self.summary(ship_id, turn)
	votes = Vote.joins(:user).where(:users => {:ship_id => ship_id}, :turn => turn)

	destinations = {}
	load_votes = 0
	unload_votes = 0

	votes.each do |vote|
	    if(vote.destination_id)
		destinations[vote.destination_id] = destinations[vote.destination_id] ? destinations[vote.destination_id]+1 : 1 
	    end

	    if vote.load
		load_votes += 1
	    end

	    if vote.unload
		unload_votes += 1
	    end
	end

	result = {
	    destinations: destinations,
	    load_votes: load_votes,
	    unload_votes: unload_votes,
	    total: votes.size
	}
    end

end
