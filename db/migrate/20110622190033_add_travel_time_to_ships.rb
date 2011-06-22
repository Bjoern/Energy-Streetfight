class AddTravelTimeToShips < ActiveRecord::Migration
  def self.up
      add_column :ships, :travel_time, :float, :default => 0
  end

  def self.down
      remove_column :ships, :travel_time
  end
end
