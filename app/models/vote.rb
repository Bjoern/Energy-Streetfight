class Vote < ActiveRecord::Base
    attr_accessible :destination_id, :unload, :load

    belongs_to :ship
    belongs_to :user

    belongs_to :load_resource, :class_name => "Resource"
    belongs_to :unload_resource, :class_name => "Resource"

    def self.summary(ship_id, turn)
	votes = Vote.joins(:user).where(:users => {:ship_id => ship_id}, :turn => turn)

	destinations = {}
	load_votes = 0
	unload_votes = 0

	load_resource = nil
	unload_resource = nil

	votes.each do |vote|
	    if(vote.destination_id)
		destinations[vote.destination_id] = destinations[vote.destination_id] ? destinations[vote.destination_id]+1 : 1 
	    end

	    if vote.load
		load_votes += 1
		load_resource = vote.load_resource
	    end

	    if vote.unload
		unload_votes += 1
		unload_resource = vote.unload_resource
	    end
	end

	result = {
	    destinations: destinations,
	    load_resource_id: load_resource ? load_resource.id : nil,
	    unload_resource_id: unload_resource ? unload_resource.id : nil,
	    load_votes: load_votes,
	    unload_votes: unload_votes,
	    total: votes.size
	}
    end

end
