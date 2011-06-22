class CreateShips < ActiveRecord::Migration
  def self.up
    create_table :ships do |t|
      t.string :house_number
      t.references :game
      t.references :destination
      t.float :speed, :default => 22
    end
  end

  def self.down
    drop_table :ships
  end
end
