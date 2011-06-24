class MeterReadingsController < ApplicationController

    def create
	reading = @current_user.meter_readings.find_or_initialize_by_turn(compute_turn)
	reading.update_attributes(params)
	reading.user = @current_user
	reading.turn = compute_turn
	reading.save

	respond_to do |format|
	    format.json {render :json => reading}
	    format.xml {render :xml => reading}
	end
    end

   #def index
#	readings = MeterReading.joins(:user).where(:users => {:ship_id => @current_user.ship_id}, :turn => @game.turn)
#
#	respond_to do |format|
#	    format.json {render :json => readings}
#	    format.xml {render :xml => readings}
#	end
#   end

    def show
	reading = @current_user.meter_readings.find(params[:id])

	respond_to do |format|
	    format.json {render :json => reading}
	    format.xml {render :xml => reading}
	end
    end

    #only one reading every three turns
    def compute_turn
	@game.next_meter_reading_turn
    end
end
