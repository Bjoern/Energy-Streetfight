require 'test_helper'

class GameUpdateTest < ActionDispatch::IntegrationTest
    fixtures :all

    def setup
	User.all.each_with_index do |user, i|

	    #create some votes
	    post "/vote", :code => user.code, :destination_id => (i % 20) + 1, :load => true, :unload => true

	    #create some meter readings
	    post "/meter_readings", :code => user.code, :reading => i
	end
    end

    def teardown

    end

    test "update game" do
	Game.update(1)

	ship1 = Ship.find(1)
	ship2 = Ship.find(2)

	#ship 1 and 2 have solved one problem each
	assert_equal(1, ship1.problems_solved, "ship 1 has solved 1 problem")
	assert_equal(1, ship2.problems_solved, "ship 2 has solved 1 problem")

	#ship 1 has resource 6 on board
	assert_equal(6, ship1.resource_id)

	#ship 2 has resource 5 on board
	assert_equal(5, ship2.resource_id)

    end
end
