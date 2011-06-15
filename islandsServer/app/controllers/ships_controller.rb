class ShipsController < ApplicationController
    skip_before_filter :authenticate, :only => [:index]

    def index
	@ships = Ship.all

	respond_to do |format|
	    format.json {render :json => @ships}
	    format.xml {render :xml => @ships}
	end
    end

    def show
	@ship = Ship.find(params[:id])

	respond_to do |format|
	    format.json {render :json => @ship}
	    format.xml {render :xml => @ship}
	end
    end
end
