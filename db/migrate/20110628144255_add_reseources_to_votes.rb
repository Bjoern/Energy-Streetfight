class AddReseourcesToVotes < ActiveRecord::Migration
  def self.up
      add_column :votes, :load_resource_id, :integer
      add_column :votes, :unload_resource_id, :integer
  end

  def self.down
      remove_column :votes, :load_resource_id
      remove_column :votes, :unload_resource_id
  end
end
