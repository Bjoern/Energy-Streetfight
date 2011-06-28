class AddHarborAndRemoveNextActionFromShips < ActiveRecord::Migration
  def self.up
      remove_column :ships, :next_action
      add_column :ships, :harbor, :integer, :default => nil
  end

  def self.down
      add_column :ships, :next_action, :string
      remove_column :ships, :harbor
  end
end
