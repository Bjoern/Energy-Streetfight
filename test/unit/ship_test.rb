require 'test_helper'

class ShipTest < ActiveSupport::TestCase
    # Replace this with your real tests.
    test "has resources" do
	hope = Ship.find_by_name('hope')
	assert(!hope.resources.empty?)

	freedom = Ship.find_by_name('freedom')

	assert(freedom.resources.empty?)
    end

end
