class RemoveDescriptionFromIsland < ActiveRecord::Migration
  def self.up
      remove_column :islands, :description
  end

  def self.down
      add_column :islands, :description, :string
  end
end
