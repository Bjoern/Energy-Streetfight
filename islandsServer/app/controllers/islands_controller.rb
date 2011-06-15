class IslandsController < ApplicationController
    skip_before_filter :authenticate, :only => [:index]

    def index
	@islands = Island.all

	respond_to do |format|
	    format.json {render :json => @islands}
	    format.xml {render :xml => @islands}
	end
    end
end
