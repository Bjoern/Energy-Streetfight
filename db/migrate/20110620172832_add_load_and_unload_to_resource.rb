class AddLoadAndUnloadToResource < ActiveRecord::Migration
  def self.up
      remove_column :votes, :resource_id
      remove_column :votes, :action

      add_column :votes, :load, :boolean, :default => false
      add_column :votes, :unload, :boolean, :default => false
  end

  def self.down
      add_column :votes, :resource_id, :integer
      add_column :votes, :action, :string

      remove_column :votes, :load
      remove_column :votes, :unload
  end
end
