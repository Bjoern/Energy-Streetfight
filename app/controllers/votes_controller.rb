class VotesController < ApplicationController
    def create
	vote = @current_user.votes.find_or_initialize_by_turn(@game.turn)
	vote.update_attributes(params)
	vote.save

	respond_to do |format|
	    format.json {render :json => vote}
	    format.xml {render :xml => vote}
	end
    end

    def summary

	turn = params[:turn] ? params[:turn].to_i : @game.turn
	result = Vote.summary(@current_user.ship, turn)

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
