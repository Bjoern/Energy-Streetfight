class RemoveShipFromVotes < ActiveRecord::Migration
  def self.up
      remove_column :votes, :ship_id
  end

  def self.down
      add_column :votes, :ship_id, :integer
  end
end
