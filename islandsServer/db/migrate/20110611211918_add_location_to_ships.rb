class AddLocationToShips < ActiveRecord::Migration
    def self.up
	add_column :ships, :x, :integer
	add_column :ships, :y, :integer
    end

    def self.down
	remove_column :ships, :x
	remove_column :ships, :y
    end
end
