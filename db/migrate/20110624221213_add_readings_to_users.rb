class AddReadingsToUsers < ActiveRecord::Migration
  def self.up
      add_column :users, :last_reading_id, :integer
      add_column :users, :previous_reading_id, :integer
      add_column :users, :energy_consumption, :integer
  end

  def self.down
      remove_column :users, :last_reading_id
      remove_column :users, :previous_reading_id
      remove_column :users, :energy_consumption
  end
end
