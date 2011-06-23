class GamesController < ApplicationController
    skip_before_filter :authenticate, :only => [:show, :start]

    def start
	puts "render start"
	render :start
    end


    def show 
	result = {
	    game_id: @game.id,
	    turn: @game.turn,
	    is_updating: @game.is_updating,
	    description: @game.description,

	    islands: @game.islands,
	    ships: @game.ships,
	    problems: @game.problems,
	    resources: @game.resources
	}

	respond_to do |format|
	    format.json {render :json => result}
	    format.xml {render :xml => result}
	end
    end
end
