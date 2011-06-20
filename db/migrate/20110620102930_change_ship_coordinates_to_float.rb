class ChangeShipCoordinatesToFloat < ActiveRecord::Migration
  def self.up
      change_column :ships, :x, :float
      change_column :ships, :y, :float
  end

  def self.down
      change_column :ships, :x, :integer
      change_column :ships, :y, :integer
  end
end
