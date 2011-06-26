class AddConsumptionToShips < ActiveRecord::Migration
  def self.up
      add_column :ships, :consumption, :float
  end

  def self.down
      remove_column :ships, :consumption
  end
end
