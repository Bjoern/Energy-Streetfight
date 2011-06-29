class VotesController < ApplicationController
    def create
	puts "create vote"
	
	vote = @current_user.votes.find_or_initialize_by_turn(@game.turn)
	vote.attributes = params
	
	puts "assigned"

	if vote.load
	    destination = @current_user.ship.destination
	    vote.load_resource = destination ? destination.resource : nil
	end

	puts "load resource assigned"

	if vote.unload
	    vote.unload_resource = @current_user.ship.resource
	end

	puts "unload resource assigned"

	vote.turn = @game.turn

	puts "vote saved: #{vote.save}"

	render :xml => vote

	#respond_to do |format|
	#    format.json {render :json => vote}
	#    format.xml {render :xml => vote}
	#end
    end

    def summary

	turn = params[:turn] ? params[:turn].to_i : @game.turn
	result = Vote.summary(@current_user.ship_id, turn)

	respond_to do |format|
	    format.json {render :json => result}
	    format.xml {render :xml => result}
	end
    end

    def show
	vote = @current_user.votes.find(params[:id])

	respond_to do |format|
	    format.json {render :json => vote}
	    format.xml {render :xml => vote}
	end
    end
end
