class UsersController < ApplicationController
    #add details to the prefilled user table
    #@current_user has been identified by code
    def register
	@current_user.update_attributes(params)

	#messages specified by flash client
	if @current_user.save
	    render :text => "mess=ok"
	else
	    render :text => "mess=fail"
	end
    end

    #check if user is logged in
    #if not, authentication filter will already have replied
    def login
	#as requested by flash client, provide OK in text
	render :text => "mess=ok"
    end
end
