require 'test_helper'

class GameUpdateTest < ActionDispatch::IntegrationTest
    fixtures :all

    def setup
	User.all.each_with_index do |user, i|

	    #create some votes
	    post "/vote", :code => user.code, :destination_id => (i % 20) + 1 

	    #create some meter readings
	    post "/meter_readings", :code => user.code, :reading => i
	end
    end

    def teardown

    end

    test "update game" do
	Game.update(1)
    end

    # Replace this with your real tests.
    test "the truth" do
	assert true
    end
end
