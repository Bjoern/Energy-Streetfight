class AddCodeToUser < ActiveRecord::Migration
  def self.up
      add_column :users, :code, :string
  end

  def self.down
      remove_column :users, :code
  end
end
