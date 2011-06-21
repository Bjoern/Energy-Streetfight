class AddUpdatingFlagToGame < ActiveRecord::Migration
  def self.up
      add_column :games, :is_updating, :boolean
  end

  def self.down
      remove_column :games, :is_updating
  end
end
