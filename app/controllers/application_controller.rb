class ApplicationController < ActionController::Base
    #TODO protect_from_forgery
    before_filter :authenticate
    before_filter :check_and_init_game
    before_filter :ensure_domain

    rescue_from Exception, :with => :show_errors

    def show_errors(exception)
	render :text => "mess=fail", :Status => 400
    end

    APP_DOMAIN = 'www.energy-streetfight.com'

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



  def ensure_domain
      puts "host: #{request.env['HTTP_HOST']}"
    if request.env['HTTP_HOST'] != APP_DOMAIN
      # HTTP 301 is a "permanent" redirect
      redirect_to "http://#{APP_DOMAIN}", :status => 301
    end
  end

end
