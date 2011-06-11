class ShipsController < ApplicationController
    def index
	@ships = Ship.all

	respond_to do |format|
	    format.json {render :json => @ships}
	end
    end
end
