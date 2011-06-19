class ProblemTypesController < ApplicationController
    skip_before_filter :authenticate, :only => [:index]

    def index
	@problem_types = ProblemType.all

	respond_to do |format|
	    format.json {render :json => @problem_types}
	    format.xml {render :xml => @problem_types}
	end
    end
end
