class ApplicationController < ActionController::Base
    #TODO protect_from_forgery
    before_filter :authenticate
    before_filter :check_and_init_game

    private

    #this is not really secure, at least not with our current 5 digit codes...
    #I bowed to the team decision here :-(
    def authenticate
	@current_user = User.find_by_code(params[:code])

	#ip = request.remote_ip

	#puts "ip address: #{ip}"

	if not @current_user
	    render :text => "mess=fail", :status => :forbidden
	end
    end

    #unused at the moment
    def authenticate_basic_auth
	authenticate_or_request_with_http_basic do |username, password|
	    @current_user = User.authenticate(username, password)
	    @current_user
	end
    end

    def check_and_init_game
	@game = Game.first
	if @game.is_updating
	    render :text => "mess=game_updating", :status => 503
	end
    end
end
