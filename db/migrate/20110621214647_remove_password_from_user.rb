class RemovePasswordFromUser < ActiveRecord::Migration
  def self.up
      remove_column :users, :password
  end

  def self.down
      add_column :users, :password, :string
  end
end
