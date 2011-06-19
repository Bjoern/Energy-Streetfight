class ResourcesController < ApplicationController
    skip_before_filter :authenticate, :only => [:index]

    def index
	@resources = Resource.all

	respond_to do |format|
	    format.json {render :json => @resources}
	    format.xml {render :xml => @resources}
	end
    end
end
