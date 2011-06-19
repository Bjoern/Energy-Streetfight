class CreateProblemTypes < ActiveRecord::Migration
  def self.up
    create_table :problem_types do |t|
      t.string :name
      t.text :description
      t.references :game

      t.timestamps
    end
  end

  def self.down
    drop_table :problem_types
  end
end
