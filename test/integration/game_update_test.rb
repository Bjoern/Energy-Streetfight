require 'test_helper'

class GameUpdateTest < ActionDispatch::IntegrationTest
    fixtures :all

    def setup
	User.all.each do |user|

	    #create some votes
	    post "/vote", :code => user.code, :destination_id => (user.id % 20) + 1, :load => true, :unload => true

	    #create some meter readings
	    post "/meter_readings", :code => user.code, :reading => user.id
	end
    end

    def teardown

    end

    test "update game" do
	User.all.each do |user|
	    #assert_equal(user.last_reading.turn, 1)
	end

	problem_counts = {}

	(1..6).each do |i|
	    problem_counts[i] = Island.where("problem_id = ?", i).count
	end

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

	(1..6).each do |i|
	   assert_equal problem_counts[i], Island.where("problem_id = ?", i).count, "number of problems of type #{i} have remained the same"
	end

	u = User.first

	assert_nil(u.last_reading, "user has no last_reading")
	assert_not_nil(u.previous_reading, "user has previous_reading")

	Ship.all.each do |ship|
	    assert_equal(22.0, ship.speed, "all ships have speed 22")
	end

	assert_equal(2, Game.find(1).turn, "turn is 2")

	puts "create second meter readings"

	User.all.each do |user|
	    #create some meter readings
	    post "/meter_readings", :code => user.code, :reading => (user.id+user.id*100)
	end

	User.all.each_with_index do |user, i|
	    assert_not_nil user.last_reading, "user has last reading"
	end

	puts "new update"

	Game.update(1)

	assert_equal(3, Game.find(1).turn, "turn is 3")

	Game.update(1)

	assert_equal(4, Game.find(1).turn, "turn is 4")

	Ship.all.each do |ship|
	    assert_equal(22.0, ship.speed, "all ships have speed 22")
	end

	Game.update(1)

	assert_equal(5, Game.find(1).turn, "turn is 5")
	Ship.all.each do |ship|

	    assert_not_equal(22.0, ship.speed, "ship #{ship.id} does not have speed 22")
	end
    end
end
