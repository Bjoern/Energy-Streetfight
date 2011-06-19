require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "has ship" do
    assert_not_nil resources(:water2).ship

    assert_nil resources(:water1).ship
  end
end
