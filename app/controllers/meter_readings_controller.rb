class MeterReadingsController < ApplicationController
    def create
	reading = @current_user.meter_readings.find_or_create_by_turn((@game.turn/3)*3)
	reading = MeterReading.new(params)
	reading.user = @current_user
	reading.turn = (@game.turn/3)*3
	reading.save

	responds_to do |format|
	    format.json {render :json => reading}
	    format.xml {render :xml => reading}
	end
    end

    def index
	readings = MeterReading.joins(:user).where(:users => {:ship_id => @current_user.ship.id})

	responds_to do |format|
	    format.json {render :json => readings}
	    format.xml {render :xml => readings}
	end
    end

    def show
	reading = @current_user.readings.find(params[:id])

	responds_to do |format|
	    format.json {render :json => reading}
	    format.xml {render :xml => reading}
	end
    end

end
