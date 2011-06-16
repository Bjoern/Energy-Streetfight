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

	responds_to do |format|
	    format.json {render :json => votes}
	    format.xml {render :xml => votes}
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
