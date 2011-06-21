class AddNextActionToShip < ActiveRecord::Migration
  def self.up
      add_column :ships, :next_action, :string, :default => nil
  end

  def self.down
      remove_column :ships, :next_action
  end
end
