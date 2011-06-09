class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.references :ship
      t.integer :turn
      t.references :user
      t.references :destination
      t.string :action
      t.references :resource

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
