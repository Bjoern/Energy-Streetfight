class VotesController < ApplicationController
    def create
	vote = @current_user.votes.find_or_initialize_by_turn(@game.turn)
	vote.update_attributes(params)
	vote.save

	responds_to do |format|
	    format.json {render :json => vote}
	    format.xml {render :xml => vote}
	end
    end

    def index
	votes = Vote.joins(:user).where(:users => {:ship_id => @current_user.ship.id}, :turn => @game.turn)

	destinations = {}
	load_votes = 0
	unload_votes = 0

	votes.each do |vote|
	    if(vote.destination_id)
		destinations[destination_id] = destinations[destination_id] ? destinations[destination_id] : 1 
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

	responds_to do |format|
	    format.json {render :json => result}
	    format.xml {render :xml => result}
	end
    end

    def show
	vote = @current_user.votes.find(params[:id])

	responds_to do |format|
	    format.json {render :json => vote}
	    format.xml {render :xml => vote}
	end
    end
end
