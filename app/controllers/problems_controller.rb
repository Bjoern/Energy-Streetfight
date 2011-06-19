class ProblemsController < ApplicationController
    skip_before_filter :authenticate, :only => [:index]

    def index
	@problems = Problem.all

	respond_to do |format|
	    format.json {render :json => @problems}
	    format.xml {render :xml => @problems}
	end
    end
end
