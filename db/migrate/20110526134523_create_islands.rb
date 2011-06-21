class CreateIslands < ActiveRecord::Migration
  def self.up
    create_table :islands do |t|
      t.string :name
      t.text :description
      t.integer :x
      t.integer :y
      t.integer :diameter
      t.references :game
    end
  end

  def self.down
    drop_table :islands
  end
end
