class UseFirstNameLastNameOnUser < ActiveRecord::Migration
  def self.up
      rename_column :users, :name, :firstName
      add_column :users, :lastName, :string
      add_column :users, :team, :string
  end

  def self.down
      rename_column :users, :firstName, :name
      remove_column :users, :lastName
      remove_column :users, :team
  end
end
