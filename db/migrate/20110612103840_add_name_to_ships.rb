class AddNameToShips < ActiveRecord::Migration
  def self.up
      add_column :ships, :name, :string
  end

  def self.down
      remove_column :ships, :name
  end
end
