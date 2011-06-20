class AddGameToUsersAndResources < ActiveRecord::Migration
  def self.up
      add_column :users, :game_id, :integer
      add_column :resources, :game_id, :integer
  end

  def self.down
      remove_column :users, :game_id
      remove_column :resources, :game_id
  end
end
