class ResourceTypesController < ApplicationController
    skip_before_filter :authenticate, :only => [:index]

    def index
	@resource_types = ResourceType.all

	respond_to do |format|
	    format.json {render :json => @resource_types}
	    format.xml {render :xml => @resource_types}
	end
    end
end
