class AddTurnToGame < ActiveRecord::Migration
    def self.up
	add_column :games, :turn, :integer
    end

    def self.down
	remove_column :games, :turn
    end
end
