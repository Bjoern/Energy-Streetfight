class ApplicationController < ActionController::Base
    protect_from_forgery
    before_filter :authenticate
    before_filter :find_game

    private

    def authenticate
	authenticate_or_request_with_http_basic do |username, password|
	    @current_user = User.authenticate(username, password)
	    @current_user
	end
    end

    def find_game
	@game = Game.first
    end
end
